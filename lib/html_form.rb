class HtmlForm
  class Field
    attr_accessor :name, :type, :required, :pattern

    def initialize(name, type, required, pattern=nil)
      @name = name
      @type = type
      @required = required
      @pattern = pattern
    end

    def set_value(value)
      @value = value
    end

    def valid?
      presence_correct && pattern_correct && correct_for_type
    end

    def error
      return "required" unless presence_correct
      return "format" unless pattern_correct
      return "not a valid #{@type}" unless correct_for_type
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
  end

  def initialize(markup)
    @markup = markup
  end

  def fields
    @fields ||= build_fields
  end

  def valid?(params)
    params.each do |key, value|
      raise ActiveModel::MassAssignmentSecurity::Error.new unless find_field(key)

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

    doc.css("input[type!='submit'], textarea").map do |input|
      type = input.name == "textarea" ? "textarea" : input.attributes["type"].value
      pattern = input.attributes.include?("pattern") ? input.attributes["pattern"].value : nil


      Field.new(
        input.attributes["id"].value,
        type,
        input.attributes.include?("required"),
        pattern
      )
    end
  end
end

require 'nokogiri'
require 'active_support/core_ext/object/blank'
require 'email_veracity'
