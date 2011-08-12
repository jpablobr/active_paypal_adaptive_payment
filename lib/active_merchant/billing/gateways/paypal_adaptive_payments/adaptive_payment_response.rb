require 'multi_json'
require 'hashie'
require 'rash'

module ActiveMerchant
  module Billing
    class AdaptivePaymentResponse

      REDIRECT_URL = 'https://www.paypal.com/webscr?cmd=_ap-payment&paykey='
      TEST_REDIRECT_URL = 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey='

      SUCCESS = 'Success'.freeze

      attr_reader :json
      alias :raw :json

      def initialize(json)
        @json = json
        @response_rash = Hashie::Rash.new(MultiJson.decode(json))
      end

      def method_missing(method, *args, &block)
        @response_rash.send(method, *args, &block)
      end

      def redirect_url_for
        Base.gateway_mode == :test ? (TEST_REDIRECT_URL + pay_key) : (REDIRECT_URL + pay_key)
      end

      def ack
        response_envelope.ack
      end

      def timestamp
        response_envelope.timestamp
      end

      def build
        response_envelope.build
      end

      def correlation_id
        response_envelope.correlation_id
      end
      alias :correlationId :correlation_id

      def success?
        ack == SUCCESS
      end
    end
  end
end
