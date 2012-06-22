# -*- coding: utf-8 -*-
require 'money'
require File.dirname(__FILE__) + '/paypal_adaptive_payments/ext'
require File.dirname(__FILE__) + '/paypal_adaptive_payment_common'
require File.dirname(__FILE__) + '/paypal_adaptive_payments/exceptions'
require File.dirname(__FILE__) + '/paypal_adaptive_payments/adaptive_payment_response'

module ActiveMerchant
  module Billing

    class PaypalAdaptivePayment < Gateway
      include PaypalAdaptivePaymentCommon

      TEST_URL = 'https://svcs.sandbox.paypal.com/AdaptivePayments/'
      LIVE_URL = 'https://svcs.paypal.com/AdaptivePayments/'

      EMBEDDED_FLOW_TEST_URL = 'https://www.sandbox.paypal.com/webapps/adaptivepayment/flow/pay'
      EMBEDDED_FLOW_LIVE_URL = 'https://www.paypal.com/webapps/adaptivepayment/flow/pay'

      module FeesPayer
        OPTIONS = %w(SENDER PRIMARYRECEIVER EACHRECEIVER SECONDARYONLY)
        OPTIONS.each { |opt| const_set(opt, opt) }
      end

      module PaymentType
        TYPES = %w(DIGITALGOODS)
        TYPES.each { |pt| const_set(pt, pt) }
      end

      self.test_redirect_url= "https://www.sandbox.paypal.com/webscr?cmd=_ap-payment&paykey="
      self.test_redirect_pre_approval_url= "https://www.sandbox.paypal.com/webscr?cmd=_ap-preapproval&preapprovalkey="
      self.supported_countries = ['US']
      self.homepage_url = 'http://x.com/'
      self.display_name = 'Paypal Adaptive Payments'

      def initialize(config = {})
        requires!(config, :login, :password, :signature, :appid)
        @config = config.dup
        super
      end

      def setup_purchase(options)
        commit('Pay', build_adaptive_payment_pay_request(options))
      end

      def details_for_payment(options)
        commit('PaymentDetails', build_adaptive_payment_details_request(options))
      end

      def get_shipping_addresses(options)
        commit('GetShippingAddresses', build_adaptive_get_shipping_addresses_request(options))
      end

      def get_payment_options(options)
        commit('GetPaymentOptions', build_adaptive_get_payment_options_request(options))
      end

      def set_payment_options(options)
        commit('SetPaymentOptions', build_adaptive_set_payment_options_request(options))
      end

      def refund(options)
        commit('Refund', build_adaptive_refund_details(options))
      end

      def execute_payment(options)
        commit('ExecutePayment', build_adaptive_execute_payment_request(options))
      end

      def preapprove_payment(options)
        commit('Preapproval', build_preapproval_payment(options))
      end

      def cancel_preapproval(options)
        commit('CancelPreapproval', build_cancel_preapproval(options))
      end

      def preapproval_details_for(options)
        commit('PreapprovalDetails', build_preapproval_details(options))
      end

      def convert_currency(options)
        commit('ConvertCurrency', build_currency_conversion(options))
      end

      def embedded_flow_url
        test? ? EMBEDDED_FLOW_TEST_URL : EMBEDDED_FLOW_LIVE_URL
      end

      def embedded_flow_url_for(token)
        "#{embedded_flow_url}?paykey=#{token}"
      end

      def debug
        {:url => @url, :request => @xml, :response => @response.json}
      end

      private

      def build_adaptive_payment_pay_request(opts)
        @xml = ''
        xml = Builder::XmlMarkup.new :target => @xml, :indent => 2
        xml.instruct!
        xml.PayRequest do |x|
          x.requestEnvelope do |x|
            x.detailLevel 'ReturnAll'
            x.errorLanguage opts[:error_language] ||= 'en_US'
          end
          x.actionType opts[:action_type] ||= 'PAY'
          x.preapprovalKey opts[:preapproval_key] if opts.key?(:preapproval_key)
          x.senderEmail opts[:sender_email] if opts.key?(:sender_email)
          x.cancelUrl opts[:cancel_url]
          x.returnUrl opts[:return_url]
          x.ipnNotificationUrl opts[:ipn_notification_url] if
            opts[:ipn_notification_url]
          x.memo opts[:memo] if opts.key?(:memo)
          x.custom opts[:custom] if opts.key?(:custom)
          x.feesPayer opts[:fees_payer] if opts[:fees_payer]
          x.pin opts[:pin] if opts[:pin]
          x.currencyCode opts[:currency_code] ||= 'USD'
          x.receiverList do |x|
            opts[:receiver_list].each do |receiver|
              x.receiver do |x|
                x.email receiver[:email]
                x.amount receiver[:amount].to_s
                x.primary receiver[:primary] if receiver.key?(:primary)
                x.paymentType receiver[:payment_type] if
                  receiver.key?(:payment_type)
                x.invoiceId receiver[:invoice_id] if
                  receiver.key?(:invoice_id)
              end
            end
          end
          x.reverseAllParallelPaymentsOnError(
            opts[:reverse_all_parallel_payments_on_error] || 'false')
          x.trackingId opts[:tracking_id] if opts[:tracking_id]
         end
      end

    def build_adaptive_execute_payment_request(opts)
        @xml = ''
        xml = Builder::XmlMarkup.new :target => @xml, :indent => 2
        xml.instruct!
        xml.ExecutePaymentRequest do |x|
          x.requestEnvelope do |x|
            x.detailLevel 'ReturnAll'
            x.errorLanguage opts[:error_language] ||= 'en_US'
          end
          x.payKey opts[:pay_key] if opts.key?(:pay_key)
          x.fundingPlanId opts[:funding_plan_id] if opts[:funding_plan_id]
         end
      end

      def build_adaptive_payment_details_request(opts)
        @xml = ''
        xml = Builder::XmlMarkup.new :target => @xml, :indent => 2
        xml.instruct!
        xml.PayRequest do |x|
          x.requestEnvelope do |x|
            x.detailLevel 'ReturnAll'
            x.errorLanguage opts[:error_language] ||= 'en_US'
          end
          x.payKey opts[:pay_key]
        end
      end

      def build_adaptive_get_shipping_addresses_request(opts)
        @xml = ''
        xml = Builder::XmlMarkup.new :target => @xml, :indent => 2
        xml.instruct!
        xml.GetShippingAddressesRequest do |x|
          x.requestEnvelope do |x|
            x.detailLevel 'ReturnAll'
            x.errorLanguage opts[:error_language] ||= 'en_US'
          end
          x.key opts[:pay_key]
        end
      end

      def build_adaptive_get_payment_options_request(opts)
        @xml = ''
        xml = Builder::XmlMarkup.new :target => @xml, :indent => 2
        xml.instruct!
        xml.GetPaymentOptionsRequest do |x|
          x.requestEnvelope do |x|
            x.detailLevel 'ReturnAll'
            x.errorLanguage opts[:error_language] ||= 'en_US'
          end
          x.payKey opts[:pay_key]
        end
      end

      def build_adaptive_set_payment_options_request(opts)
        opts[:sender] ||= {}

        @xml = ''
        xml = Builder::XmlMarkup.new :target => @xml, :indent => 2
        xml.instruct!
        xml.SetPaymentOptionsRequest do |x|
          x.requestEnvelope do |x|
            x.detailLevel 'ReturnAll'
            x.errorLanguage opts[:error_language] ||= 'en_US'
          end
          x.senderOptions do |x|
            x.shareAddress opts[:sender][:share_address] if opts[:sender][:share_address]
            x.sharePhoneNumber opts[:sender][:share_phone_number] if opts[:sender][:share_phone_number]
            x.requireShippingAddressSelection opts[:sender][:require_shipping_address_selection] if opts[:sender][:require_shipping_address_selection]
            x.referrerCode opts[:sender][:referrerCode] if opts[:sender][:referrerCode]
          end
          unless opts[:display_options].blank?
            x.displayOptions do |x|
              x.emailHeaderImageUrl opts[:display_options][:email_header_image_url] if opts[:display_options][:email_header_image_url]
              x.emailMarketingImageUrl opts[:display_options][:email_marketing_image_url] if opts[:display_options][:email_marketing_image_url]
              x.headerImageUrl opts[:display_options][:header_image_url] if opts[:display_options][:header_image_url]
              x.businessName opts[:display_options][:business_name] if opts[:display_options][:business_name]
            end
          end
          opts[:receiver_options].try(:each) do |receiver_options|
            x.receiverOptions do |x|
              x.description receiver_options[:description] if receiver_options[:description]
              x.customId receiver_options[:custom_id] if receiver_options[:custom_id]
              unless receiver_options[:invoice_data].blank?
                x.invoiceData do |x|
                  receiver_options[:invoice_data][:item].try(:each) do |item|
                    x.item do |x|
                      x.name item[:name] if item[:name]
                      x.identifier item[:identifier] if item[:identifier]
                      x.price item[:price] if item[:price]
                      x.itemPrice item[:item_price] if item[:item_price]
                      x.itemCount item[:item_count] if item[:item_count]
                    end
                  end
                  x.totalTax receiver_options[:invoice_data][:total_tax] if receiver_options[:invoice_data][:total_tax]
                  x.totalShipping receiver_options[:invoice_data][:total_shipping] if receiver_options[:invoice_data][:total_shipping]
                end
              end
              x.receiver do |x|
                x.email receiver_options[:receiver][:email] if receiver_options[:receiver][:email]
                unless receiver_options[:receiver][:phone].blank?
                  x.phone do |x|
                    x.countryCode receiver_options[:receiver][:phone][:country_code]
                    x.phoneNumber receiver_options[:receiver][:phone][:phone_number]
                    x.extension receiver_options[:receiver][:phone][:extension] if receiver_options[:receiver][:phone][:extension]
                  end
                end
              end
              x.referrerCode receiver_options[:referrer_code] if receiver_options[:referrer_code]
            end
          end
          x.payKey opts[:pay_key]
        end
      end

      def build_adaptive_refund_details(options)
        @xml = ''
        xml = Builder::XmlMarkup.new :target => @xml, :indent => 2
        xml.instruct!
        xml.RefundRequest do |x|
          x.requestEnvelope do |x|
            x.detailLevel 'ReturnAll'
            x.errorLanguage options[:error_language] ||= 'en_US'
          end
          x.actionType 'REFUND'
          if options[:pay_key]
            x.payKey options[:pay_key]
          end
          if options[:transaction_id]
            x.payKey options[:transaction_id]
          end
          if options[:tracking_id]
            x.trackingId options[:tracking_id]
          end
          x.cancelUrl options[:cancel_url]
          x.returnUrl options[:return_url]
          x.currencyCode options[:currency_code] ||= 'USD'
          x.receiverList do |x|
            options[:receiver_list].each do |receiver|
              x.receiver do |x|
                x.amount receiver[:amount]
                x.paymentType receiver[:payment_type] ||= 'GOODS'
                x.invoiceId receiver[:invoice_id] if receiver[:invoice_id]
                x.email receiver[:email]
              end
            end
          end
          x.feesPayer options[:fees_payer] ||= 'EACHRECEIVER'
        end
      end

      def build_preapproval_payment(options)
        opts = {
          :currency_code => "USD",
          :start_date => DateTime.current
        }.update(options)

        @xml = ''
        xml = Builder::XmlMarkup.new :target => @xml, :indent => 2
        xml.instruct!
        xml.PreapprovalRequest do |x|
          # request envelope
          x.requestEnvelope do |x|
            x.detailLevel 'ReturnAll'
            x.errorLanguage opts[:error_language] ||= 'en_US'
            x.senderEmail opts[:senderEmail] if opts.has_key?(:senderEmail)
          end

          # required preapproval fields
          x.endingDate opts[:end_date].strftime("%Y-%m-%dT%H:%M:%S")
          x.startingDate opts[:start_date].strftime("%Y-%m-%dT%H:%M:%S")
          x.maxTotalAmountOfAllPayments opts[:max_amount]
          x.maxAmountPerPayment opts[:maxAmountPerPayment] if opts.has_key?(:maxAmountPerPayment)
          x.memo opts[:memo] if opts.has_key?(:memo)
          x.maxNumberOfPayments opts[:maxNumberOfPayments] if
            opts.has_key?(:maxNumberOfPayments)
          x.currencyCode options[:currency_code]
          x.cancelUrl opts[:cancel_url]
          x.returnUrl opts[:return_url]
          x.displayMaxTotalAmount opts[:displayMaxTotalAmount] if opts.has_key?(:displayMaxTotalAmount)

          # notify url
          x.ipnNotificationUrl opts[:notify_url] if
            opts.has_key?(:notify_url)
        end
      end

      def build_preapproval_details(options)
        @xml = ''
        xml = Builder::XmlMarkup.new :target => @xml, :indent => 2
        xml.instruct!
        xml.PreapprovalDetailsRequest do |x|
          x.requestEnvelope do |x|
            x.detailLevel 'ReturnAll'
            x.errorLanguage options[:error_language] ||= 'en_US'
          end
          x.preapprovalKey options[:preapproval_key]
          x.getBillingAddress options[:get_billing_address] if
            options[:get_billing_address]
        end
      end

      def build_cancel_preapproval(options)
        @xml = ''
        xml = Builder::XmlMarkup.new :target => @xml, :indent => 2
        xml.instruct!
        xml.PreapprovalDetailsRequest do |x|
          x.requestEnvelope do |x|
            x.detailLevel 'ReturnAll'
            x.errorLanguage options[:error_language] ||= 'en_US'
          end
          x.preapprovalKey options[:preapproval_key]
        end
      end

      def build_currency_conversion(options)
        @xml = ''
        xml = Builder::XmlMarkup.new :target => @xml, :indent => 2
        xml.instruct!
        xml.ConvertCurrencyRequest do |x|
          x.requestEnvelope do |x|
            x.detailLevel 'ReturnAll'
            x.errorLanguage options[:error_language] ||= 'en_US'
          end
          x.baseAmountList do |x|
            options[:currency_list].each do |currency|
              x.currency do |x|
                x.amount currency[:amount]
                x.code currency[:code ]
              end
            end
          end
          x.convertToCurrencyList do |x|
            options[:to_currencies].each do |k,v|
              x.currencyCode "#{v}"
            end
          end
        end
      end

      def commit(action, data)
        @response = AdaptivePaymentResponse.new(post_through_ssl(action, data), data, action)
      end

      def post_through_ssl(action, parameters = {})
        headers = {
          "X-PAYPAL-REQUEST-DATA-FORMAT" => "XML",
          "X-PAYPAL-RESPONSE-DATA-FORMAT" => "JSON",
          "X-PAYPAL-SECURITY-USERID" => @config[:login],
          "X-PAYPAL-SECURITY-PASSWORD" => @config[:password],
          "X-PAYPAL-SECURITY-SIGNATURE" => @config[:signature],
          "X-PAYPAL-APPLICATION-ID" => @config[:appid],
        }
        action_url(action)
        request = Net::HTTP::Post.new(@url.path)
        request.body = @xml
        headers.each_pair { |k,v| request[k] = v }
        request.content_type = 'text/xml'
        server = Net::HTTP.new(@url.host, 443)
        server.use_ssl = true
        server.start { |http| http.request(request) }.body
      end

      def endpoint_url
        test? ? TEST_URL : LIVE_URL
      end

      def test?
        @config[:test] || Base.gateway_mode == :test
      end

      def action_url(action)
        @url = URI.parse(endpoint_url + action)
      end
    end
  end
end
