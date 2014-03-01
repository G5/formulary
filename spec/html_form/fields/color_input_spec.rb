require 'spec_helper'

describe Formulary::HtmlForm::Fields::ColorInput do
  let(:markup_with_label) { "<label for='field'>Field</label>#{markup}" }
  let(:html_form) { Formulary::HtmlForm.new(markup_with_label) }

  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::ColorInput.compatible_with?(element) }
    let(:markup) { %{<input type="#{type}" name="name" />} }

    context "color type" do
      let(:type) { "color" }
      it { should be_true }
    end

    context "text type" do
      let(:type) { "text" }
      it { should be_false }
    end
  end

  describe "validations" do
    subject(:input) { Formulary::HtmlForm::Fields::ColorInput.new(html_form, element) }
    let(:markup) { %{<input type="color" id="field" name="name" />} }

    context "with a valid color" do
      before { input.set_value("#123DEF") }

      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "with an invalid color address" do
      before { input.set_value("invalid!") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' is not a valid color hex value") }
    end

    context "with a nil color" do
      before { input.set_value(nil) }

      it { should be_valid }
      its(:error) { should be_blank }
    end
  end

  it_should_behave_like "a field that allows the required attribute" do
    let(:markup_with_required) { %{<input type="color" id="field" name="field" required />} }
    let(:markup_without_required) { %{<input type="color" id="field" name="field" />} }
    let(:valid_value) { "#123456" }
  end

  it_should_behave_like "a field that allows the pattern attribute" do
    let(:markup) { %{<input type="color" id="field" name="field" pattern="^#[A-F]*$" />} }
    let(:valid_value) { "#ABCDEF" }
  end
end
