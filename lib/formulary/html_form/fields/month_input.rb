module Formulary::HtmlForm::Fields
  class MonthInput < DateInput
    def self.compatible_type
      "month"
    end

    def display_format
      "YYYY-MM"
    end

    def datetime_format
      "%Y-%m"
    end
  end
end
