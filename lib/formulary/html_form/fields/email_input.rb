module Formulary::HtmlForm::Fields
  class EmailInput < Input
    # The acceptable email pattern in the standard is defined in a language
    # that might not be possible to use in Ruby.  Or if it is, we haven't spent
    # the time to find out or not.  We did find this supposedly compatible
    # regex on StackOverflow and it passes our tests so we're rolling with that
    # for now.
    #
    # http://stackoverflow.com/questions/4940120/is-there-a-java-implementation-of-the-html5-input-email-validation
    REGEX = /[A-Za-z0-9!#$%&'*+-\/=?^_`{|}~]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+/

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
      return true if @value.match(REGEX)
    end
  end
end
