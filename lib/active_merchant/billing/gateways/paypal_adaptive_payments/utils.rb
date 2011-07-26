module ActiveMerchant; module Billing; module AdaptiveUtils

def currency_to_two_places amount
  return 0.01 if amount < 1
  ("%.2f" % amount).to_f
end

end; end; end
