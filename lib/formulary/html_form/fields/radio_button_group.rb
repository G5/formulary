module Formulary::HtmlForm::Fields
  class RadioButtonGroup < Field
    def self.supports_required?
      true
    end

    def initialize(group_name, elements)
      @group_name, @elements = group_name, elements
    end

    def name
      @group_name
    end

    def valid?
      super && value_in_list?
    end

    def error
      return super if super.present?
      return "choose" if !value_in_list?
    end

  protected

    def required?
      @elements.each do |element|
        return true if element.attributes.include?("required")
      end
      return false
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
