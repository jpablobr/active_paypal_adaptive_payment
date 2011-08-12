Gem::Specification.new do |s|
  s.name        = "active_paypal_adaptive_payment"
  s.version     = '0.2.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jose Pablo Barrantes"]
  s.email       = ["xjpablobrx@gmail.com"]
  s.homepage    = "http://github.com/jpablobr/active_paypal_adaptive_payment"
  s.summary     = "ActiveMercant PayPal Adaptive Payment Library"
  s.description = "This library is meant to interface with PayPal web services Adaptive Payment Gateway Library."

  s.required_rubygems_version = ">= 1.3.6"
  s.files = Dir.glob("lib/**/*") + %w(MIT-LICENSE readme.md CHANGELOG)
  s.require_path = %w(lib)

    if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activemerchant>, [">= 1.5.1"])
      s.add_dependency(%q<multi_json>, [">= 1.0.0"])
      s.add_dependency(%q<rash>, [">= 0.3.0"])
      s.add_dependency(%q<money>, [">= 3.6.0"])
    else
      s.add_dependency(%q<activemerchant>, [">= 1.5.1"])
      s.add_dependency(%q<multi_json>, [">= 1.0.0"])
      s.add_dependency(%q<rash>, [">= 0.3.0"])
      s.add_dependency(%q<money>, [">= 3.6.0"])
    end
  else
      s.add_dependency(%q<activemerchant>, [">= 1.5.1"])
      s.add_dependency(%q<multi_json>, [">= 1.0.0"])
      s.add_dependency(%q<rash>, [">= 0.3.0"])
      s.add_dependency(%q<money>, [">= 3.6.0"])
  end
end
