lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "active_paypal_adaptive_payment"
  s.version     = '0.1.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jose Pablo Barrantes"]
  s.email       = ["xjpablobrx@gmail.com"]
  s.homepage    = "http://github.com/jpablobr/active_paypal_adaptive_payment"
  s.summary     = "ActiveMercant PayPal Adaptive Payment Library"
  s.description = "This library is meant to interface with PayPal web services Adaptive Payment Gateway Library."

  s.required_rubygems_version = ">= 1.3.6"
  s.files = Dir.glob("lib/**/*") + %w(MIT-LICENSE README.markdown CHANGELOG)
  s.require_path = %w(lib)

  s.add_dependency(%q<activemerchant>, [">= 1.5.1"])
  s.add_dependency(%q<activesupport>, [">= 3.0.7"])
  s.add_dependency(%q<builder>, [">= 2.0.0"])
end
