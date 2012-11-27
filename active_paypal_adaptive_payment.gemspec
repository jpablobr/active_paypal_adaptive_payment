# encoding: utf-8
Gem::Specification.new do |s|
  s.name        = "active_paypal_adaptive_payment"
  s.version     = '0.3.16'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jose Pablo Barrantes"]
  s.email       = ["xjpablobrx@gmail.com"]
  s.homepage    = "http://github.com/jpablobr/active_paypal_adaptive_payment"
  s.summary     = "ActiveMercant PayPal Adaptive Payment Library"
  s.description = <<-eof
    This library is meant to interface with PayPal's Adaptive Payment Gateway.
  eof

  s.required_rubygems_version = ">= 1.3.6"
  s.files = Dir.glob("lib/**/*") + %w(MIT-LICENSE README.md CHANGELOG.md)
  s.require_path = %w(lib)

  s.add_dependency(%q<activemerchant>, [">= 1.5.1"])
  s.add_dependency(%q<multi_json>, [">= 1.0.0"])
  s.add_dependency(%q<hashie>, [">= 1.2.0"])
  s.add_dependency(%q<money>, [">= 3.6.0"])
  s.add_dependency(%q<mocha>, [">= 0.10.0"])
end
