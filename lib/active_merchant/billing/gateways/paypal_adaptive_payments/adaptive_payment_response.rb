module ActiveMerchant; module Billing;  module AdaptivePaymentResponses

class AdaptivePaypalSuccessResponse

  REDIRECT_URL = 'https://www.paypal.com/webscr?cmd=_ap-payment&paykey='
  TEST_REDIRECT_URL = 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey='

  attr_reader :paykey

  def initialize json
    @paykey = json['payKey']
    @params = json
  end

  def redirect_url_for
    Base.gateway_mode == :test ? (TEST_REDIRECT_URL + @paykey) : (REDIRECT_URL + @paykey)
  end

  def ack
    @params['responseEnvelope']['ack']
  end

  def paymentExecStatus
    @params['paymentExecStatus']
  end

  def transactionStatus
    @params['transactionStatus']
  end

  def senderEmail
    @params['senderEmail']
  end

  def actionType
    @params['actionType']
  end

  def feesPayer
    @params['feesPayer']
  end

  def currencyCode
    @params['currencyCode']
  end

  def payKey
    @params['payKey']
  end

  def correlationId
    @params['responseEnvelope']['correlationId']
  end

  def build
    @params['responseEnvelope']['build']
  end

  def refundInfoList
    @params['refundInfoList']
  end

  def preapprovalKey
    @params['preapprovalKey']
  end

  def curPaymentsAmount
    @params['curPaymentsAmount']
  end

  def status
    @params['status']
  end

  def curPeriodAttempts
    @params['curPeriodAttempts']
  end

  def approved
    @params['approved']
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

end

class AdaptivePaypalErrorResponse

  def initialize error
    @raw = error
    @errlist = ActiveSupport::JSON.decode(error)
  end

  def debug
    @raw.inspect
  end

  def ack
    @raw['responseEnvelope']['ack']
  end

  def timestamp
    @raw['responseEnvelope']['timestamp']
  end

  def build
    @raw['responseEnvelope']['build']
  end

  def correlationId
    @raw['responseEnvelope']['correlationId']
  end

  def errormessage
    @errlist['error']
  end
end

end; end; end
