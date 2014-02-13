module Formulary::HtmlForm::Fields
  class CheckboxGroup < FieldGroup
    def self.compatible_type
      "checkbox"
    end

    def self.supports_required?
      true
    end

    def initialize(html_form, group_name, elements)
      super
      @values = []
    end

    def set_value(value)
      @values = [value].flatten
    end

  protected

    def presence_correct?
      @elements.each do |element|
        if element.attributes.include?("required")
          return false unless @values.include?(value_from_element(element))
        end
      end
      return true
    end

    def value_in_list?
      return true if @values.empty?
      allowed_values = @elements.map { |e| value_from_element(e) }
      (allowed_values & @values) == @values
    end

    # Our exhaustive testing concludes that browsers submit "on" when the
    # checkbox has no value.
    def value_from_element(element)
      element.attributes["value"].try(:value) || "on"
    end
  end
end
