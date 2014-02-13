require 'spec_helper'

describe Formulary::HtmlForm::Fields::EmailInput do
  let(:markup_with_label) { "<label for='field'>Field</label>#{markup}" }
  let(:html_form) { Formulary::HtmlForm.new(markup_with_label) }

  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::EmailInput.compatible_with?(element) }
    let(:markup) { %{<input type="#{type}" name="name" />} }

    context "text type" do
      let(:type) { "text" }
      it { should be_false }
    end

    context "email type" do
      let(:type) { "email" }
      it { should be_true }
    end
  end

  it_should_behave_like "a field that allows the required attribute" do
    let(:markup_with_required) { %{<input type="email" id="field" name="field" required />} }
    let(:markup_without_required) { %{<input type="email" id="field" name="field" />} }
    let(:valid_value) { "test@example.com" }
  end

  it_should_behave_like "a field that allows the pattern attribute" do
    let(:markup) { '<input type="email" id="field" name="field" pattern="@example\.com$" />' }
    let(:valid_value) { "test@example.com" }
  end

  describe "validations" do
    subject(:input) { Formulary::HtmlForm::Fields::EmailInput.new(html_form, element) }
    let(:markup) { %{<input type="email" id="field" name="name" />} }

    context "with a valid email address" do
      before { input.set_value("test@example.com") }

      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "with an invalid email address" do
      before { input.set_value("invalid!") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' is not a valid email address") }
    end

    context "with a nil email address" do
      before { input.set_value(nil) }

      it { should be_valid }
      its(:error) { should be_blank }
    end
  end
end
