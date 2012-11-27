# Active PayPal Adaptive Payment

This library is meant to interface with PayPal's Adaptive Payment Gateway.

[Active Merchant]:http://www.activemerchant.org

![Active PayPal Adaptive Payment](https://github.com/jpablobr/active_paypal_adaptive_payment/raw/master/doc/split.jpg)

## Supported

* Payments
* Preapprovals
* Refunds
* Currency conversions
* getting/setting payment options
* getting shipping addresses
* getting a redirect for the embedded pay flow
* More soon!

## Installation

Add the following line to your app Gemfile:

    gem "active_paypal_adaptive_payment"

    bundle install

## Implementation

See [iAuction: An Adaptive Payments Tutorial Featuring Parallel Payments](https://www.x.com/docs/DOC-2505) tutorial for more info.

### Init

    gateway =  ActiveMerchant::Billing::PaypalAdaptivePayment.new(
      :login => "acutio_1313133342_biz_api1.gmail.com",
      :password => "1255043567",
      :signature => "Abg0gYcQlsdkls2HDJkKtA-p6pqhA1k-KTYE0Gcy1diujFio4io5Vqjf",
      :appid => "APP-80W284485P519543T" )

### Pre-approved payment

    gateway.preapprove_payment (
      :return_url => "returnURL",
      :cancel_url => "cancelURL",
      :senderEmail =>"email address of sender",
      :start_date => Time.now,
      :end_date => Time.now + (60*60*24) * 30,
      :currency_code =>"currency code",
      :max_amount => "maxTotalAmountOfAllPayments",
      :maxNumberOfPayments => "maxNumberOfPayments" )

      response = gateway.setup_purchase(
        :return_url => url_for(:action => 'action', :only_path => false),
        :cancel_url => url_for(:action => 'action', :only_path => false),
        :notify_url => url_for(:action => 'notify_action', :only_path => false),
        :receiver_list => recipients
      )

    # For redirecting the customer to the actual paypal site to finish the payment.
    redirect_to (gateway.redirect_pre_approval_url_for(response["payKey"]))

### Cancel pre-approved payment

     gateway.cancel_preapproval(:preapproval_key => "preapprovalkey")
 
### Chained payments

    def checkout
      recipients = [{:email => 'receiver_email',
                     :amount => some_amount,
                     :primary => true},
                    {:email => 'receiver_email',
                     :amount => recipient_amount,
                     :primary => false}
                     ]
      response = gateway.setup_purchase(
        :return_url => url_for(:action => 'action', :only_path => false),
        :cancel_url => url_for(:action => 'action', :only_path => false),
        :ipn_notification_url => url_for(:action => 'notify_action', :only_path => false),
        :receiver_list => recipients
      )

      # For redirecting the customer to the actual paypal site to finish the payment.
      redirect_to (gateway.redirect_url_for(response["payKey"]))
    end

Set the `:primary` flag to `false` for each recipient for a split payment.

Maybe also check the tests for a sample implementation.

Notes:

In `development` environment it's very important to define
ActiveMerchant environment you will be using to test your app like so:

```ruby
#config/environments/{environment.rb}
App::Application.configure do
  config.setting...
end
ActiveMerchant::Billing::Base.mode = :test
```

### Setting advanced payment and invoice options

To be able to set additional payment and invoice options, such as item names,
shipping costs, custom logos, etc., you must first create a payment, then set
the options and then direct the user to the payment page:

```ruby
purchase = gateway.setup_purchase(
  :action_type => "CREATE", # This is in contrast to the default PAY action
  …                         # as above
)

gateway.set_payment_options(
  :display_options => {
    :business_name    => "Your Business",
    :header_image_url => "http://cdn.yourbusiness.com/logo-for-paypal.png"
  },
  :pay_key => purchase["payKey"],
  :receiver_options => [
    {
      :description => "Your purchase of XYZ",
      :invoice_data => {
        :item => [
          { :name => "Item #1", :item_count => 1, :item_price => 100, :price => 100 },
          { :name => "Item #2", :item_count => 2, :item_price => 10, :price => 20 }
        ],
        :total_shipping => 5,
        :total_tax => 10
      },
      :receiver => { :email => "receiver1@example.com" }
    },
    {
      :description => "XYZ Processing fee",
      :invoice_data => {
        :item => [{ :name => "Fee", :item_count => 1, :item_price => 10, :price => 10 }]
      },
      :receiver => { :email => "receiver2@example.com" }
    }
  ]
)

redirect_to(gateway.redirect_url_for(purchase["payKey"]))
```

See the implementation of ActiveMerchant::Billing::PaypalAdaptivePayment#build_adaptive_set_payment_options_request
for all available options and [Operation SetPaymentOptions API](https://cms.paypal.com/cms_content/US/en_US/files/developer/PP_AdaptivePayments.pdf)
for a description of them.

## Testing

First modify the `test/fixtures.yml` to fit your app credentials (You
will need at least a PayPal developer account).

After that you can run them like this:

    $ ruby -Ilib test/test_paypal_adaptive_payment.rb

## Debugging

Use either gateway.debug or response.debug this gives you the json
response, the xml sent and the url it was posted to.

From the Rails console it can be accessed like such:

    ActiveMerchant::Billing::PaypalAdaptivePayment

`PaypalAdaptivePayment#debug` or `AdaptivePaymentResponse#debug` return the raw
xml request, raw json response and the URL of the endpoint.

## TODO

* More/better Documentation.
* Improve/change the tests implementation by maybe run them off
  fixture data and use a separate script/test for actually invoking
  requests to PayPal. This will allow other developers to implement
  the without being required to set and request the credentials from
  PayPal process.

## Contributors

* Jose Pablo Barrantes (<http://jpablobr.com/>)
* Zarne Dravitzki (<http://github.com/zarno>)
* LeviRosol (<https://github.com/LeviRosol>)
* Florian95 (<https://github.com/Florian95>)
* akichatov (<https://github.com/akichatov>)
* Patrick Sinclair (<https://github.com/metade>)
* Mike Pence (<https://github.com/mikepence>)
* Nicola Junior Vitto (<https://github.com/njvitto>)
* Vidar Eldøy (https://github.com/eldoy)
* Niels Ganser (https://github.com/Nielsomat)
* saizai (Sai) (https://github.com/saizai)
* Dmtiriy Budnik (https://github.com/dmitriybudnik)
* Sjors Provoost (https://github.com/Sjors)

## Other previous contributors where some code was taken from.

* [Tommy Chheng](http://tommy.chheng.com)
  - [Paypal Adaptive Ruby Gem Released](http://tommy.chheng.com/2009/12/29/paypal-adaptive-ruby-gem-released/)
  - [paypal_adaptive](https://github.com/tc/paypal_adaptive)

* [lamp (Matt)](https://github.com/lamp)
  - [paypal_adaptive_gateway](https://github.com/lamp/paypal_adaptive_gateway)

* [sentientmonkey (Scott Windsor)](https://github.com/sentientmonkey)
  - [active_merchant](https://github.com/sentientmonkey/active_merchant)

* [sijokg](https://github.com/sijokg)
  - [active_merchant](https://github.com/sijokg/active_merchant)

## Some PayPal Adaptive payment resources.

* [Adaptive Payment Fee Calculation Analysis](https://www.x.com/docs/DOC-2401)
* [ActiveMerchant paypaladaptive payments gateway](http://www.rorexperts.com/activemerchant-paypaladaptive-payments-gateway-t2245.html)
* [Trying to use with Paypal adaptive payments](http://groups.google.com/group/activemerchant/browse_thread/thread/866ad7dc5019c199/2a280b7dc396c41b?lnk=gst&q=adaptive+payment#2a280b7dc396c41b)
* [adpative payments (chained)](http://groups.google.com/group/activemerchant/browse_thread/thread/165c3e0bf4d10c02/aa8dd082b58354d9?lnk=gst&q=adaptive+payment#aa8dd082b58354d9)
* [Testing with a sandbox account without being logged on developer.paypal.com](http://groups.google.com/group/activemerchant/browse_thread/thread/ad69fc8116bfdf64/483f22071bb25e25?lnk=gst&q=adaptive+payment#483f22071bb25e25)
* [Split a transaction to distribute funds to two accounts?](http://groups.google.com/group/activemerchant/browse_thread/thread/e1f53087aee9d0c/2cd63df363861ce1?lnk=gst&q=adaptive+payment#2cd63df363861ce1)

## Note on Patches/Pull Requests:

* Fork the project.
* Make your feature addition or bug fix.
* Send me a pull request. Bonus points for topic branches.

## Copyright:

(The MIT License)

Copyright 2011 Jose Pablo Barrantes. MIT Licence, so go for it.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, an d/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
