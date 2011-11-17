require File.dirname(__FILE__) + '/test_helper'

class TestPaypalAdaptivePayment < MiniTest::Unit::TestCase

  def setup
    @gateway = ActiveMerchant::Billing::PaypalAdaptivePayment.new(fixtures(:credentials))
  end

  def test_successful_pay
    assert response = @gateway.setup_purchase(fixtures(:pay_options))
    assert_equal true, response.success?, "Unsuccessful Transaction"
    assert_equal "CREATED","#{response.payment_exec_status}"
  end

  def test_redirect_url_for
    assert response = @gateway.setup_purchase(fixtures(:pay_options))
    refute_nil key = response["pay_key"]
    url = @gateway.redirect_url_for(key)
    assert_match /#{key}$/, url, "Could not generate the proper redirect_url_for URL"
  end

  def test_redirect_url_for
    assert response = @gateway.setup_purchase(fixtures(:pay_options))
    refute_nil key = response["pay_key"]
    url = @gateway.redirect_url_for(key)
    assert_match /#{key}$/, url, "Could not generate the proper redirect_url_for URL"
  end

  def test_redirect_pre_approval_url_for
    assert response = @gateway.setup_purchase(fixtures(:pay_options))
    refute_nil key = response["preapprovalKey"]
    url = @gateway.redirect_pre_approval_url_for(key)
    assert_match /#{key}$/, url, "Could not generate the proper redirect_url_for URL"
  end

  def test_embedded_flow_url_for
    assert response = @gateway.setup_purchase(fixtures(:pay_options))
    refute_nil key = response["pay_key"]
    url = @gateway.embedded_flow_url_for(key)
    assert_match /#{key}$/, url, "Could not generate the proper embedded_flow_url_for URL"
  end

  def test_successful_paydetails
    assert response = @gateway.details_for_payment(fixtures(:paydetails_options))
    assert_equal true, response.success?, "Unsuccessful Transaction"
  end

  def test_successful_shipping_addresses
    assert response = @gateway.get_shipping_addresses(fixtures(:paydetails_options))
    assert_equal true, response.success?, "Unsuccessful Transaction"
  end

  def test_successful_get_payment_options
    assert response = @gateway.get_payment_options(fixtures(:paydetails_options))
    assert_equal true, response.success?, "Unsuccessful Transaction"
  end

  def test_successful_set_payment_options
    assert response = @gateway.set_payment_options(fixtures(:paydetails_options))
    assert_equal true, response.success?, "Unsuccessful Transaction"
  end

  def test_successful_preapproval
    assert response = @gateway.preapprove_payment(preapproval_options)
    assert_equal true, response.success?, "Unsuccessful Transaction"
  end

end
