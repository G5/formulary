module Formulary::HtmlForm::Fields
  class Input < Field
    def self.compatible_with?(element)
      element.name == "input" &&
      element.attributes["type"].value == compatible_type
    end

    def self.supports_required?
      true
    end

    def valid?
      super && pattern_correct?
    end

    def error
      return super if super.present?
      return "format" unless pattern_correct?
    end

  protected

    def pattern_correct?
      return true if pattern.blank? || @value.blank?
      @value.match(Regexp.new(pattern))
    end

    def pattern
      @element.attributes["pattern"].try(:value)
    end
  end
end
