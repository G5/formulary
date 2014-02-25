module Formulary::HtmlForm::Fields
  class NumberInput < Input
    def self.compatible_type
      "number"
    end

    def initialize(html_form, element)
      @html_form, @element = html_form, element
      @min = @element.attributes['min'].try('value')
      @max = @element.attributes['max'].try('value')
      @step = @element.attributes['step'].try('value')
    end

    def valid?
      super && number_correct? && min_correct? && max_correct? && step_correct?
    end

    def error
      return super if super.present?
      return "'#{label}' must be a valid number" unless number_correct?
      return "'#{label}' must be greater than or equal to #{@min}" unless min_correct?
      return "'#{label}' must be less than or equal to #{@max}" unless max_correct?
      return "'#{label}' must be a step of #{@step}, the nearest valid values are #{@lower_step} and #{@higher_step}" unless step_correct?
    end

  protected

    def number_correct?
      return true if @value.blank?
      return true if @value.match(/^\d*$/)
      false
    end

    def min_correct?
      return true if @value.blank?
      return true if @min.blank?
      return true if @value.to_i >= @min.to_i
      false
    end

    def max_correct?
      return true if @value.blank?
      return true if @max.blank?
      return true if @value.to_i <= @max.to_i
      false
    end

    def step_correct?
      return true if @value.blank?
      return true if @step.blank?
      start = @min.to_i || 0
      step = @step.to_i
      value = @value.to_i
      match_mod = start % step
      return true if value % step == match_mod

      @lower_step = value - (value % step)
      @higher_step = value + (step - (value % step))

      false
    end
  end
end
