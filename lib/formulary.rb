require 'nokogiri'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'email_veracity'

# Don't try and determine if this email address is legitimate, just validate
# the provided address.
EmailVeracity::Config[:skip_lookup] = true

module Formulary
  class HtmlForm
    FIELD_TYPES = []
    FIELD_GROUP_TYPES = []
  end
end

require "formulary/version"
require "formulary/html_form/fields"
require "formulary/html_form/labels"
require "formulary/html_form"
