module Formulary::HtmlForm::Fields
  class TelInput < Input
    def self.compatible_type
      "tel"
    end
  end
end
