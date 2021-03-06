module Formulary::HtmlForm::Fields
  class FieldGroup < Field
    def self.compatible_with?(elements)
      elements.all? do |e|
        e.name == "input" && e.attributes["type"].value == compatible_type
      end
    end

    def initialize(html_form, group_name, elements)
      @html_form, @group_name, @elements = html_form, group_name, elements
    end

    def name
      @group_name
    end

    def valid?
      super && value_in_list?
    end

    def error
      return super if super.present?
      return "'#{label}' must be chosen from the available options" if !value_in_list?
    end
  end
end
