## 0.3.16 (2012-11-27)

  - Also allow details_for_payment to find a transaction by transaction_id. (pull req #39) by https://github.com/Sjors

## 0.3.15 (2012-07-09)

  - PayPal requests headers should be case insensitive fix. (pull req #27) by dmitriybudnik
  
## 0.3.14 (2012-07-06)

  - Expose raw and request objects for easier logging / debugging (pull req #25) by saizai
  - rm unusued refund fields (pull req #25) by saizai
  - Also added: receiver_list is optional for refunds (refunds everything on that paykey if not specified) (pull req #25) by saizai
  
## 0.3.12 (2012-05-18)

- Added option displayMaxTotalAmount to build_preapproval_payment to display amount with paypal on payment (04b37c9) by eldoy

## 0.3.12 (2012-05-02)

  - Add displayOptions and receiverOptions support to
    SetPaymentOptionsRequest (Niels Ganser) by 597ecad
  
## 0.3.11 (2012-04-28)

  - Added option :action_type to build_adaptive_payment_pay_request to enable delayed chained payments (3df6948) by eldoy
  
  
## 0.3.10 (2012-03-30)

  - Added referrerCode in SetPaymentOptions request (by njvitto)
  
## 0.3.3 (16/Nov/11)

  - add functionality to allow a user to redirect to the correct URL
    when creating a pre-approval request. In addition, the
    setup_purchase now allows for the preapproval_key to be submitted
    and passed along to paypal. (LeviRosol (<https://github.com/LeviRosol>))

## 0.3.2

  - build_adaptive_payment_details_request pay_key fix.

## 0.3.1

  - Add Support of ExecutePayment.

## 0.3.0

  - IPN implemeted

## 0.2.5

  - Added custom filed to the request builder.

## 0.2.4

  - renamed the pay method to setup_purchase, again, more like active_merchant.
  - added paypal_adaptive_payment_common.rb for handling the redirects more like active_merchant
  - removed the autoloads, they look kind of messy

## 0.2.3

  - `autoload` the helper libs.

## 0.2.2

  - Array fix https://github.com/lsegal/yard/issues/370

## 0.2.1

   - Removed action pack as a dependency

## 0.2.0

 - Fix tests.
 - Added fixtures.yml.

## 0.1.2

 - Few typo fixes by LeviRosol
