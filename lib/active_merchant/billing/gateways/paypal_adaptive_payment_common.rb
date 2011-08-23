module ActiveMerchant
  module Billing
    module PaypalAdaptivePaymentCommon
      def self.included(base)
        base.cattr_accessor :test_redirect_url
        base.cattr_accessor :live_redirect_url
        base.live_redirect_url = 'https://www.paypal.com/webscr?cmd=_ap-payment&paykey='
      end

      def redirect_url
        test? ? test_redirect_url : live_redirect_url
      end

      def redirect_url_for(token)
        redirect_url + token
      end
    end
  end
end
