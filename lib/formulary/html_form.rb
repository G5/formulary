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

      doc.css("input[type!='submit'], textarea, select").map do |field|
        field_klass = FIELD_TYPES.detect { |k| k.compatible_with?(field) }
        if field_klass.nil?
          raise UnsupportedFieldType.new("I can't handle this field: #{field.inspect}")
        end
        field_klass.new(field)
      end
    end
  end

  class UnexpectedParameter < StandardError

  end

  class UnsupportedFieldType < StandardError

  end
end
