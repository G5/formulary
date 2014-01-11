module Formulary
  class HtmlForm
    SINGULAR_FIELD_SELECTOR = <<-EOS
      input[type!='submit'][type!='radio'][type!='checkbox'],
      textarea,
      select
    EOS

    GROUPED_FIELD_SELECTOR = <<-EOS
      input[type='radio'],
      input[type='checkbox']
    EOS

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
      @fields || build_fields
    end

    def find_field(name)
      fields.detect { |field| field.name == name.to_s }
    end

    def build_fields
      @fields = []
      doc = Nokogiri::HTML(@markup)

      build_singular_fields_from(doc)
      build_grouped_fields_from(doc)
    end

    def build_singular_fields_from(doc)
      doc.css(SINGULAR_FIELD_SELECTOR.strip).map do |element|
        field_klass = FIELD_TYPES.detect { |k| k.compatible_with?(element) }
        if field_klass.nil?
          raise UnsupportedFieldType.new("I can't handle this field: #{element.inspect}")
        end
        @fields << field_klass.new(element)
      end
    end

    def build_grouped_fields_from(doc)
      grouped_elements = doc.css(GROUPED_FIELD_SELECTOR.strip).group_by do |element|
        element.attributes["name"].value
      end

      grouped_elements.each do |element_group|
        group_name, elements = *element_group

        group_klass = FIELD_GROUP_TYPES.detect { |k| k.compatible_with?(elements) }
        @fields << group_klass.new(group_name, elements)
      end
    end
  end

  class UnexpectedParameter < StandardError
  end

  class UnsupportedFieldType < StandardError
  end
end
