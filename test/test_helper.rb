$:.unshift File.expand_path('../../lib', __FILE__)

require 'yaml'
require 'minitest/autorun'
require 'active_merchant'
require 'active_paypal_adaptive_payment'

ActiveMerchant::Billing::Base.mode = :test

module ActiveMerchant
  module Fixtures

    private

    def preapproval_options
      now = Time.now
      {
        :return_url => "http://example.com/return",
        :cancel_url => "http://example.com/cancel",
        :senderEmail => "sender@example.com",
        :start_date => now,
        :end_date => now + (60*60*24) * 180, # 180 days in the future
        :currency_code => "USD",
        :max_amount => "100",
        :maxNumberOfPayments => "10"
      }
    end

    def all_fixtures
      @@fixtures ||= load_fixtures
    end

    def fixtures(key)
      data = all_fixtures[key] || raise(StandardError,
                                  "No fixture data was found for '#{key}'")
      data.dup
    end

    def load_fixtures
      file = File.join(File.dirname(__FILE__), 'fixtures.yml')
      yaml_data = YAML.load(File.read(file))
      symbolize_keys(yaml_data)
      yaml_data
    end

    def symbolize_keys(hash)
      return unless hash.is_a?(Hash)
      hash.symbolize_keys!
      hash.each{|k,v| symbolize_keys(v)}
    end
  end
end

MiniTest::Unit::TestCase.class_eval do
  include ActiveMerchant::Fixtures
end
