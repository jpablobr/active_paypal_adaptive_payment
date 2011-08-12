require 'test_helper'

class TestPaypalAdaptivePayment < MiniTest::Unit::TestCase

  def setup
    @gateway = ActiveMerchant::Billing::PaypalAdaptivePayment.new(fixtures(:credentials))
  end

  def test_successful_pay
    assert response = @gateway.pay(fixtures(:pay_options))
    assert_equal true, response.success?, "Unsuccessful Transaction"
    assert_equal "CREATED","#{response.payment_exec_status}"
  end

  def test_successful_paydetails
    assert response = @gateway.details_for_payment(fixtures(:paydetails_options))
    assert_equal true, response.success?, "Unsuccessful Transaction"
  end

  def test_successful_preapproval
    assert response = @gateway.preapprove_payment(preapproval_options)
    assert_equal true, response.success?, "Unsuccessful Transaction"
  end
end
