module Formulary::HtmlForm::Fields
  class HiddenInput < Input
    def self.compatible_type
      "hidden"
    end
  end
end
