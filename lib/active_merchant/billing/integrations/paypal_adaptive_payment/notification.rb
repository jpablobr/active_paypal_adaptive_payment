# encoding: utf-8
require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module PaypalAdaptivePayment
        # Parser and handler for incoming Instant payment notifications from paypal.
        # The Example shows a typical handler in a rails application. Note that this
        # is an example, please read the Paypal API documentation for all the details
        # on creating a safe payment controller.
        #
        # Example
        #
        #   class BackendController < ApplicationController
        #     include ActiveMerchant::Billing::Integrations
        #
        #     def paypal_ipn
        #       notify = PaypalAdaptivePayment::Notification.new(request.raw_post)
        #
        #       order = Order.find(notify.item_id)
        #
        #       if notify.acknowledge
        #         begin
        #
        #           if notify.complete? and order.total == notify.amount
        #             order.status = 'COMPLETED'
        #
        #             shop.ship(order)
        #           else
        #             logger.error("Failed to verify Paypal's notification, please investigate")
        #           end
        #
        #         rescue => e
        #           order.status = 'ERROR'
        #           raise
        #         ensure
        #           order.save
        #         end
        #       end
        #
        #       render :nothing
        #     end
        #   end
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          include PostsData

          # Was the transaction complete?
          def complete?
            status == "COMPLETED"
          end

          # Status of transaction. List of possible values:
          # <tt>CREATED</tt>::
          # <tt>COMPLETED</tt>::
          # <tt>INCOMPLETE</tt>::
          # <tt>ERROR</tt>::
          # <tt>REVERSALERROR</tt>::
          # <tt>PROCESSING</tt>::
          # <tt>PENDING</tt>::
          def status
            params['status']
          end

          # Id of this transaction (paypal number)
          def transaction_id
            params['transaction[0].id_for_sender_txn']
          end

          def type
            params['action_type']
          end

          # This is the item number which we submitted to paypal
          # The custom field is also mapped to item_id because PayPal
          # doesn't return item_number in dispute notifications
          def item_id
            params['item_number'] || params['custom']
          end

          # This is the invoice which you passed to paypal
          def invoice
            params['transaction[0].invoiceId']
          end

          # Was this a test transaction?
          def test?
            params['test_ipn'] == '1'
          end

          def account
            params['business'] || params['transaction[0].receiver']
          end

          # Acknowledge the transaction to paypal. This method has to be called after a new
          # ipn arrives. Paypal will verify that all the information we received are correct and will return a
          # ok or a fail.
          #
          # Example:
          #
          #   def paypal_ipn
          #     notify = PaypalAdaptivePaymentNotification.new(request.raw_post)
          #
          #     if notify.acknowledge
          #       ... process order ... if notify.complete?
          #     else
          #       ... log possible hacking attempt ...
          #     end
          def acknowledge
            payload =  raw

            response = ssl_post(Paypal.service_url + '?cmd=_notify-validate', payload,
              'Content-Length' => "#{payload.size}",
              'User-Agent'     => "Active Merchant -- http://activemerchant.org"
            )

            raise StandardError.new("Faulty paypal result: #{response}") unless ["VERIFIED", "INVALID"].include?(response)

            response == "VERIFIED"
          end
        end
      end
    end
  end
end
