module Formulary::HtmlForm::Fields
  class Field
    def self.supports_required?
      false
    end

    def initialize(element)
      @element = element
    end

    def name
      @element.attributes["name"].value
    end

    def set_value(value)
      @value = value
    end

    def valid?
      supports_required? && presence_correct?
    end

    def error
      return "required" if supports_required? && !presence_correct?
    end

  protected

    def supports_required?
      self.class.supports_required?
    end

    def presence_correct?
      if required? && @value.blank?
        return false
      else
        return true
      end
    end

    def required?
      @element.attributes.include?("required")
    end
  end
end
