require 'nokogiri'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'

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
