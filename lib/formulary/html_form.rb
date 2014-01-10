module Formulary
  class HtmlForm
    def initialize(markup)
      @markup = markup
      fields
    end

    def valid?(params)
      params.each do |key, value|
        raise UnexpectedParameter.new("Got unexpected field '#{key}'") unless find_field(key)

        find_field(key).set_value(value)
      end

      fields.all?(&:valid?)
    end

    def errors
      fields.each_with_object({}) do |field, hash|
        hash[field.name] = field.error unless field.valid?
      end
    end

  protected

    def fields
      @fields ||= build_fields
    end

    def find_field(name)
      fields.detect { |field| field.name == name.to_s }
    end

    def build_fields
      doc = Nokogiri::HTML(@markup)

      fields = doc.css("input[type!='submit'][type!='radio'], textarea, select").map do |element|
        field_klass = FIELD_TYPES.detect { |k| k.compatible_with?(element) }
        if field_klass.nil?
          raise UnsupportedFieldType.new("I can't handle this field: #{element.inspect}")
        end
        field_klass.new(element)
      end

      grouped_elements = doc.css("input[type='radio']").group_by do |element|
        element.attributes["name"].value
      end

      grouped_elements.each do |element_group|
        fields << Fields::RadioButtonGroup.new(*element_group)
      end

      fields
    end
  end

  class UnexpectedParameter < StandardError

  end

  class UnsupportedFieldType < StandardError

  end
end
