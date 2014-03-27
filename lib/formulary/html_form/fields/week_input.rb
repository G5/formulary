module Formulary::HtmlForm::Fields
  class WeekInput < DateInput
    def self.compatible_type
      "week"
    end

    def display_format
      "YYYY-W##"
    end

    def datetime_format
      "%Y-W%U"
    end
  end
end
