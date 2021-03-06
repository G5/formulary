require 'formulary/html_form/fields/field'
require 'formulary/html_form/fields/field_group'
require 'formulary/html_form/fields/input'

require 'formulary/html_form/fields/text_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::TextInput
require 'formulary/html_form/fields/search_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::SearchInput
require 'formulary/html_form/fields/password_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::PasswordInput
require 'formulary/html_form/fields/color_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::ColorInput
require 'formulary/html_form/fields/number_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::NumberInput
require 'formulary/html_form/fields/range_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::RangeInput
require 'formulary/html_form/fields/email_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::EmailInput
require 'formulary/html_form/fields/tel_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::TelInput
require 'formulary/html_form/fields/hidden_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::HiddenInput
require 'formulary/html_form/fields/date_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::DateInput
require 'formulary/html_form/fields/month_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::MonthInput
require 'formulary/html_form/fields/week_input'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::WeekInput
require 'formulary/html_form/fields/textarea'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::Textarea
require 'formulary/html_form/fields/select'
Formulary::HtmlForm::FIELD_TYPES << Formulary::HtmlForm::Fields::Select

require 'formulary/html_form/fields/radio_button_group'
Formulary::HtmlForm::FIELD_GROUP_TYPES << Formulary::HtmlForm::Fields::RadioButtonGroup
require 'formulary/html_form/fields/checkbox_group'
Formulary::HtmlForm::FIELD_GROUP_TYPES << Formulary::HtmlForm::Fields::CheckboxGroup
