module Formulary::HtmlForm::Fields
  class DateInput < Input
    def self.compatible_type
      "date"
    end

    def valid?
      super && date_correct?
    end

    def error
      return super if super.present?
      return "'#{label}' is not a properly formatted date, please use YYYY-MM-DD" unless date_correct?
    end

  protected

    def date_correct?
      return true if @value.blank?
      Date.strptime(@value, "%Y-%m-%d")
    rescue ArgumentError => e
      if e.message.include?("invalid date")
        return false
      else
        raise
      end
    end
  end
end
