module Formulary::HtmlForm::Fields
  class ColorInput < Input
    def self.compatible_type
      "color"
    end

    def valid?
      super && color_correct?
    end

    def error
      return super if super.present?
      return "'#{label}' is not a valid color hex value" unless color_correct?
    end

  protected

    def color_correct?
      return true if @value.blank?
      return true if @value.match(/\A#[0-9A-F]{6}\z/)
      false
    end
  end
end
