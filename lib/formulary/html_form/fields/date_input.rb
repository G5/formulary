module Formulary::HtmlForm::Fields
  class DateInput < Input
    def self.compatible_type
      "date"
    end

    def initialize(html_form, element)
      @html_form, @element = html_form, element
      @min = @element.attributes['min'].try('value')
      @max = @element.attributes['max'].try('value')
    end

    def valid?
      super && date_correct? && min_correct? && max_correct?
    end

    def error
      return super if super.present?
      return "'#{label}' is not a properly formatted date, please use YYYY-MM-DD" unless date_correct?
      return "'#{label}' must be a date after #{@min}" unless min_correct?
      return "'#{label}' must be a date before #{@max}" unless max_correct?
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

    def min_correct?
      return true if @value.blank?
      return true if @min.blank?
      return true if @value >= @min
      false
    end

    def max_correct?
      return true if @value.blank?
      return true if @max.blank?
      return true if @value <= @max
      false
    end
  end
end
