# Active PayPal Adaptive Payment

This library is meant to interface with PayPal web services Adaptive Payment Gateway Library.

[Active Merchant]:http://www.activemerchant.org

![Active PayPal Adaptive Payment](https://github.com/jpablobr/active_paypal_adaptive_payment/raw/master/doc/split.jpg)

## Supported

* payments
* preapprovals
* refunds
* currency conversions
* more soon!

## Installation

Add the following line to your app Gemfile:

    gem "active_paypal_adaptive_payment"

## Implementation

See [iAuction: An Adaptive Payments Tutorial Featuring Parallel Payments](https://www.x.com/docs/DOC-2505) tutorial for more info.

### Pre-approved paymen

    gateway.preapprove_payment (
      :return_url => "returnURL",
      :cancel_url => "cancelURL",
      :senderEmail =>"email address of sender",
      :start_date => Time.now,
      :end_date => Time.now + (60*60*24) * 30,
      :currency_code =>"currency code",
      :max_amount => "maxTotalAmountOfAllPayments",
      :maxNumberOfPayments => "maxNumberOfPayments" )

### Cancel pre-approved payment

    gateway.cancel_preapproval(:preapproval_key => "preapprovalkey"

### Chained payments

    def checkout
      recipients = [{:email => 'receiver_email',
                     :amount => some_amount,
                     :primary => true},
                    {:email => 'receiver_email',
                     :amount => recipient_amount,
                     :primary => false}
                     ]
      response = gateway.pay(
        :return_url => url_for(:action => 'action', :only_path => false),
        :cancel_url => url_for(:action => 'action', :only_path => false),
        :notify_url => url_for(:action => 'notify_action', :only_path => false),
        :receiver_list => recipients
      )
      redirect_to response.redirect_url_for
    end

Set the `:primary` flag to `false` for each recipient for a split payment.

## Debugging

Use either gateway.debug or response.debug this gives you the json
response, the xml sent and the url it was posted to.

From the Rails console it can be accessed like such:

    ActiveMerchant::Billing::PaypalAdaptivePayment

`PaypalAdaptivePayment#debug` or `AdaptivePaymentResponse#debug` return the raw
xml request, raw json response and the URL of the endpoint.

## TODO

* Documentation
* More tests

## Contributors

* Jose Pablo Barrantes (<http://jpablobr.com/>)
* Zarne Dravitzki (<http://github.com/zarno>)
* LeviRosol (<https://github.com/LeviRosol>)

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
