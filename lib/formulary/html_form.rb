module Formulary
  class HtmlForm
    class Field
      attr_accessor :name, :type, :required, :pattern

      def initialize(name, type, required, pattern=nil, valid_values)
        @name = name
        @type = type
        @required = required
        @pattern = pattern
        @valid_values = valid_values
      end

      def set_value(value)
        @value = value
      end

      def valid?
        presence_correct && pattern_correct && correct_for_type && value_in_options
      end

      def error
        return "required" unless presence_correct
        return "format" unless pattern_correct
        return "not a valid #{@type}" unless correct_for_type
        return "must choose an item from the list" unless value_in_options
      end

    protected

      def presence_correct
        !required || @value.present?
      end

      def pattern_correct
        return true if @pattern.blank? || @value.blank?
        @value.match(Regexp.new(@pattern))
      end

      def correct_for_type
        return true if @value.blank?

        case @type
        when "email"
          EmailVeracity::Address.new(@value).valid?
        else
          true
        end
      end

      def value_in_options
        return true if @valid_values.nil?
        @valid_values.include?(@value)
      end
    end

    def initialize(markup)
      @markup = markup
    end

    def fields
      @fields ||= build_fields
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

    def find_field(name)
      fields.detect { |field| field.name == name.to_s }
    end

    def build_fields
      doc = Nokogiri::HTML(@markup)

      doc.css("input[type!='submit'], textarea, select").map do |input|
        type = case input.name
        when "textarea"
          "textarea"
        when "select"
          "select"
        else
          input.attributes["type"].value
        end
        pattern = input.attributes.include?("pattern") ? input.attributes["pattern"].value : nil

        valid_values = nil
        if input.name == "select"
          options = input.css("option")

          valid_values = options.map do |option|
            option["value"] ? option["value"] : option.text
          end
        end

        Field.new(
          input.attributes["name"].value,
          type,
          input.attributes.include?("required"),
          pattern,
          valid_values
        )
      end
    end
  end

  class UnexpectedParameter < StandardError

  end
end
