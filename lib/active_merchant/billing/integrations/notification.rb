# encoding: utf-8
module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      class Notification

        private

        # Take the posted data and move the relevant data into a hash
        def parse(post)
          @raw = post.to_s
          for line in @raw.split('&')
            key, value = CGI.unescape(*line).scan( %r{^([A-Za-z0-9_.\[\]]+)\=(.*)$} ).flatten
            params[key] = CGI.unescape(value)
          end
        end
      end
    end
  end
end
