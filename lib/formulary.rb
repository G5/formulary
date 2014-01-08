require 'nokogiri'
require 'active_support/core_ext/object/blank'
require 'email_veracity'

# Don't try and determine if this email address is legitimate, just validate
# the provided address.
EmailVeracity::Config[:skip_lookup] = true

require "formulary/version"
require "formulary/html_form"
