# encoding: utf-8
require '../../../test_helper'

class PaypalAdaptivePaymentNotificationTest < MiniTest::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @paypal = PaypalAdaptivePayment::Notification.new(http_raw_data)
  end

  def test_accessors
    assert @paypal.complete?
    assert_equal "COMPLETED", @paypal.status
    assert_equal "21U696918R561262L", @paypal.transaction_id
    assert 'tobi@leetsoft.com' , @paypal.account
    assert @paypal.test?
  end

  def test_acknowledgement
    PaypalAdaptivePayment::Notification.any_instance.stubs(:ssl_post).returns('VERIFIED')
    assert @paypal.acknowledge

    PaypalAdaptivePayment::Notification.any_instance.stubs(:ssl_post).returns('INVALID')
    assert !@paypal.acknowledge
  end

  def test_send_acknowledgement
    PaypalAdaptivePayment::Notification.any_instance.expects(:ssl_post).with(
      "#{PaypalAdaptivePayment.service_url}?cmd=_notify-validate",
      http_raw_data,
      {
        'Content-Length' => "#{http_raw_data.size}",
        'User-Agent' => "Active Merchant -- http://activemerchant.org"
      }).returns('VERIFIED')

    assert @paypal.acknowledge
  end

  def test_payment_successful_status
    notification = PaypalAdaptivePayment::Notification.new('status=COMPLETED')
    assert_equal 'COMPLETED', notification.status
  end

  def test_payment_pending_status
    notification = PaypalAdaptivePayment::Notification.new('status=PENDING')
    assert_equal 'PENDING', notification.status
  end

  def test_payment_failure_status
    notification = PaypalAdaptivePayment::Notification.new('status=FAILED')
    assert_equal 'FAILED', notification.status
  end

  def test_respond_to_acknowledge
    assert @paypal.respond_to?(:acknowledge)
  end

  def test_item_id_mapping
    notification = PaypalAdaptivePayment::Notification.new('item_number=1')
    assert_equal '1', notification.item_id
  end

  def test_custom_mapped_to_item_id
    notification = PaypalAdaptivePayment::Notification.new('custom=1')
    assert_equal '1', notification.item_id
  end

  def test_nil_notification
    notification = PaypalAdaptivePayment::Notification.new(nil)

    PaypalAdaptivePayment::Notification.any_instance.stubs(:ssl_post).returns('INVALID')
    assert !@paypal.acknowledge
  end

  def test_raw_data
    p parse(http_raw_data)
  end

  private

  def parse(post)
    params = Hash.new
    @raw = post.to_s
    for line in @raw.split('&')
      key, value = CGI.unescape(*line).scan( %r{^([A-Za-z0-9_.\[\]]+)\=(.*)$} ).flatten
      params[key] = CGI.unescape(value)
    end
  end

  def http_raw_data
    'transaction%5B0%5D.is_primary_receiver=true&transaction%5B0%5D.id_for_sender_txn=21U696918R561262L&log_default_shipping_address_in_transaction=false&transaction%5B0%5D.receiver=tony_1314838793_biz%40jewellerymarketingsolutions.com&action_type=PAY&ipn_notification_url=https%3A//jewellover-staging.heroku.com//notify_url&transaction%5B1%5D.paymentType=SERVICE&transaction%5B0%5D.amount=USD+129.95&charset=windows-1252&transaction_type=Adaptive+Payment+PAY&transaction%5B1%5D.id_for_sender_txn=3G055529P0825922L&transaction%5B0%5D.invoiceId=R423025426&transaction%5B1%5D.is_primary_receiver=false&transaction%5B0%5D.status=Completed&notify_version=UNVERSIONED&transaction%5B0%5D.id=7DH16329KA864600D&cancel_url=http%3A//jewellover-staging.heroku.com/orders/R423025426/edit&transaction%5B1%5D.status_for_sender_txn=Completed&transaction%5B1%5D.receiver=tony_1310518490_biz%40jewellerymarketingsolutions.com&verify_sign=AFcWxV21C7fd0v3bYYYRCpSSRl31A3m2pTT3pSTjjy9HegIFzz2Gqs8v&sender_email=buyer_1317558127_per%40gcds.com.au&fees_payer=PRIMARYRECEIVER&transaction%5B0%5D.status_for_sender_txn=Completed&return_url=http%3A//jewellover-staging.heroku.com/checkout/paypal_adaptive_payment_finish&transaction%5B0%5D.paymentType=SERVICE&memo=Goods+from+Jewellover+Staging&transaction%5B1%5D.amount=USD+13.00&reverse_all_parallel_payments_on_error=false&transaction%5B1%5D.pending_reason=NONE&pay_key=AP-5S664027HY4327447&transaction%5B1%5D.id=0VM9950879183652M&transaction%5B0%5D.pending_reason=NONE&transaction%5B1%5D.invoiceId=R423025426&status=COMPLETED&transaction%5B1%5D.status=Completed&test_ipn=1&payment_request_date=Mon+Oct+03+05%3A43%3A08+PDT+2011'
  end
end
