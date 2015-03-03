module Formulary::HtmlForm::Fields
  class Field
    def self.supports_required?
      false
    end

    def initialize(html_form, element)
      @html_form, @element = html_form, element
    end

    def name
      @element.attributes["name"].value
    end

    def get_value_from_data_field(data_field)
      find_first_element_with_data_field(data_field) if @element.blank? && @elements
      @element.attributes.include?(data_field) ? @element.attributes[data_field].value : nil
    end

    def set_value(value)
      @value = value
    end

    def valid?
      supports_required? && presence_correct?
    end

    def error
      return "'#{label}' is required" if supports_required? && !presence_correct?
    end

    def label
      @label ||= \
        begin
          l = @html_form.label_for_field(name)

          if l.nil? then nil
          elsif l.is_a?(String) then l
          else l["fieldset"]
          end
        end
    end

    def is_hidden?
      self.class.compatible_type == "hidden" rescue false
    end

  protected

    def find_first_element_with_data_field(data_field)
      @elements.each do |e|
        if e.attributes.include?(data_field)
          @element = e
          return
        end
      end
    end

    def supports_required?
      self.class.supports_required?
    end

    def presence_correct?
      if required? && @value.blank?
        return false
      else
        return true
      end
    end

    def required?
      @element.attributes.include?("required")
    end
  end
end
