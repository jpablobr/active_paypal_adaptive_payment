module ActiveMerchant
  module Billing
    module AdaptivePaymentResponses
      
      class AdaptivePaypalSuccessResponse
        
        BASE_REDIRECT_URL = 'https://www.paypal.com/webscr?cmd='
        TEST_BASE_REDIRECT_URL = 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd='
        PAY_COMMAND = '_ap-payment&paykey='
        PREAPPROVAL_COMMAND = '_ap-preapproval&preapprovalkey='
        
        attr_reader :paykey, :preapprovalkey
        
        def initialize json
          
          @paykey = json['payKey']
          @preapprovalkey = json['preapprovalKey']
          @params = json
        end
        
        def redirect_url_for
          (Base.gateway_mode == :test ? TEST_BASE_REDIRECT_URL : BASE_REDIRECT_URL) + PAY_COMMAND + @paykey
        end

        def redirect_preapproval_url_for
          (Base.gateway_mode == :test ? TEST_BASE_REDIRECT_URL : BASE_REDIRECT_URL) + PREAPPROVAL_COMMAND + @preapprovalkey
        end
        
        def ack
          @params['responseEnvelope']['ack']
        end    
        
        def method_missing name
          begin
            @params[name.to_s]
          rescue
            raise AttributenotFound
          end
        end
                  
        def [](key)
          return @params[key] if @params.include? key
          raise AttributenotFound
        end

        def status
          @params['status']
        end

        def refund_status
          @params["refundInfoList"]["refundInfo"].first["refundStatus"]
        end

        def execute_status
          @params['paymentExecStatus']
        end

        def refund_complete?
          refund_status == 'REFUNDED' || refund_status == 'ALREADY_REVERSED_OR_REFUNDED'
        end

        def execute_complete?
          execute_status == 'COMPLETED'
        end

      end
      
      class AdaptivePaypalErrorResponse
        
        def initialize error
          @raw = error
        end
            
        def debug
          @raw.inspect
        end
        
      end
      
    end
  end
end
