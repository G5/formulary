require 'formulary/html_form/fields/field'
require 'formulary/html_form/fields/input'
require 'formulary/html_form/fields/text_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::TextInput
require 'formulary/html_form/fields/email_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::EmailInput
require 'formulary/html_form/fields/tel_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::TelInput
require 'formulary/html_form/fields/hidden_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::HiddenInput
require 'formulary/html_form/fields/textarea'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::Textarea
require 'formulary/html_form/fields/select'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::Select

require 'formulary/html_form/fields/radio_button_group'
