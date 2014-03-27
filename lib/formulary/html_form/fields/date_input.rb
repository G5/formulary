module Formulary::HtmlForm::Fields
  class DateInput < Input
    def self.compatible_type
      "date"
    end

    def display_format
      "YYYY-MM-DD"
    end

    def datetime_format
      "%Y-%m-%d"
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
      return "'#{label}' is not a properly formatted #{self.class.compatible_type}, please use #{display_format}" unless date_correct?
      return "'#{label}' must be a #{self.class.compatible_type} after #{@min}" unless min_correct?
      return "'#{label}' must be a #{self.class.compatible_type} before #{@max}" unless max_correct?
    end

  protected

    def date_correct?
      return true if @value.blank?
      Date.strptime(@value, datetime_format)
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
