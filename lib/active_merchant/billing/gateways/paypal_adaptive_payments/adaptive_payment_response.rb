      require 'multi_json'
require 'hashie'

module ActiveMerchant
  module Billing
    class AdaptivePaymentResponse < Response

      SUCCESS = 'Success'.freeze

      attr_reader :json, :request, :action, :response, :xml_request
      alias :raw :json
      alias :raw_request :xml_request

      def initialize(json, xml_request = nil, action = nil)
        @json = json
        @response = Hashie::Rash.new(MultiJson.decode(json))
        @xml_request = xml_request
        @request =  Hashie::Rash.from_xml(xml_request)
        @action = action
      end

      def method_missing(method, *args, &block)
        @response.send(method, *args, &block)
      end

      # def redirect_url_for
      #   Base.gateway_mode == :test ? (TEST_REDIRECT_URL + pay_key) : (REDIRECT_URL + pay_key)
      # end

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
