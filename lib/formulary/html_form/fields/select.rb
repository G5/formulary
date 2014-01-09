module Formulary::HtmlForm::Fields
  class Select < Field
    def self.compatible_with?(element)
      element.name == "select"
    end

    def valid?
      valid_values.include?(@value)
    end

    def error
      return "choose" unless valid?
    end

  protected

    def valid_values
      @valid_values ||= \
        @element.css("option").map do |option|
          option["value"] ? option["value"] : option.text
        end
    end
  end
end
