$:.unshift File.dirname(__FILE__)

begin
  require 'active_support'
  require 'active_merchant/common'
rescue LoadError
  require 'rubygems'
  require 'active_support'
  require 'active_merchant/common'
end

dir = File.dirname(__FILE__) + '/active_merchant/billing/gateways'
require dir + '/paypal_adaptive_payment'
