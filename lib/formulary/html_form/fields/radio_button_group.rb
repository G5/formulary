module Formulary::HtmlForm::Fields
  class RadioButtonGroup < FieldGroup
    def self.compatible_type
      "radio"
    end

    def self.supports_required?
      true
    end

  protected

    def required?
      @elements.any? { |e| e.attributes.include?("required") }
    end

    def value_in_list?
      return true if @value.blank?
      valid_values.include?(@value)
    end

    def valid_values
      @valid_values ||= \
        @elements.map do |element|
          element.attributes["value"].value
        end
    end
  end
end
