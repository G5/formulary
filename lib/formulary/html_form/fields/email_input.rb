module Formulary::HtmlForm::Fields
  class EmailInput < Input
    def self.compatible_type
      "email"
    end

    def valid?
      super && email_correct?
    end

    def error
      return super if super.present?
      return "'#{label}' is not a valid email address" unless email_correct?
    end

  protected

    def email_correct?
      return true if @value.blank?
      EmailVeracity::Address.new(@value).valid?
    end
  end
end
