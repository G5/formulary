module Formulary
  class HtmlForm
    include Labels

    SINGULAR_FIELD_SELECTOR = <<-EOS
      input[type!='submit'][type!='button'][type!='reset'][type!='image'][type!='radio'][type!='checkbox'],
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
        if value.kind_of?(Hash)
          value.each do |nested_key, nested_value|
            set_field_value("#{key}[#{nested_key}]", nested_value)
          end
        else
          set_field_value(key, value)
        end
      end

      fields.all?(&:valid?)
    end

    def errors
      fields.each_with_object({}) do |field, hash|
        hash[field.name] = field.error unless field.valid?
      end
    end

    def is_hidden_field?(name)
      field = find_field(name)
      !!field.try(:is_hidden?)
    end

    def data_field_value(name, data_field)
      field = find_field(name)
      field.get_value_from_data_field(data_field)
    end

  protected

    def document
      @document ||= Nokogiri::HTML(@markup)
    end

    def set_field_value(field_name, value)
      field = find_field(field_name)
      raise UnexpectedParameter.new("Got unexpected field '#{field_name}'") unless field
      field.set_value(value)
    end

    def fields
      @fields || build_fields
    end

    def find_field(name)
      fields.detect { |field| field.name == name.to_s }
    end

    def build_fields
      @fields = []

      build_singular_fields_from
      build_grouped_fields_from
    end

    def build_singular_fields_from
      document.css(SINGULAR_FIELD_SELECTOR.strip).map do |element|
        field_klass = FIELD_TYPES.detect { |k| k.compatible_with?(element) }
        if field_klass.nil?
          raise UnsupportedFieldType.new("I can't handle this field: #{element.inspect}")
        end
        @fields << field_klass.new(self, element)
      end
    end

    def build_grouped_fields_from
      grouped_elements = document.css(GROUPED_FIELD_SELECTOR.strip).group_by do |element|
        element.attributes["name"].value
      end

      grouped_elements.each do |element_group|
        group_name, elements = *element_group

        group_klass = FIELD_GROUP_TYPES.detect { |k| k.compatible_with?(elements) }
        if group_klass.nil?
          raise UnsupportedFieldType.new("I can't handle these fields: #{elements.inspect}")
        end
        @fields << group_klass.new(self, group_name, elements)
      end
    end
  end

  class UnexpectedParameter < StandardError
  end

  class UnsupportedFieldType < StandardError
  end
end
