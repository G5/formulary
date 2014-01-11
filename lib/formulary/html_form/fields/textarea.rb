module Formulary::HtmlForm::Fields
  class Textarea < Field
    def self.compatible_with?(element)
      element.name == "textarea"
    end

    def self.supports_required?
      true
    end
  end
end

