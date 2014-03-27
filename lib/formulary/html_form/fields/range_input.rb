module Formulary::HtmlForm::Fields
  class RangeInput < NumberInput
    def self.compatible_type
      "range"
    end
  end
end
