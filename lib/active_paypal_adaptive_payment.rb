require 'active_merchant'

dir = File.dirname(__FILE__) + '/active_merchant/billing/gateways'
require dir + '/paypal_adaptive_payment'
