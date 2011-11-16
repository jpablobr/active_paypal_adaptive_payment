## 0 0.3.3 (16/Nov/11)

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
