require 'spec_helper'

describe Formulary::HtmlForm::Fields::NumberInput do
  let(:markup_with_label) { "<label for='field'>Field</label>#{markup}" }
  let(:html_form) { Formulary::HtmlForm.new(markup_with_label) }

  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::NumberInput.compatible_with?(element) }
    let(:markup) { %{<input type="#{type}" name="name" />} }

    context "number type" do
      let(:type) { "number" }
      it { should be_true }
    end

    context "email type" do
      let(:type) { "email" }
      it { should be_false }
    end
  end

  describe "validations" do
    subject(:input) { Formulary::HtmlForm::Fields::NumberInput.new(html_form, element) }
    let(:markup) { %{<input type="number" id="field" name="name" min="2" max="10" step="2" />} }

    context "with a valid number" do
      before { input.set_value("8") }

      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "with not a number" do
      before { input.set_value("invalid!") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be a valid number") }
    end

    context "with a number less than the min" do
      before { input.set_value("0") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be greater than or equal to 2") }
    end

    context "with a number greater than the max" do
      before { input.set_value("11") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be less than or equal to 10") }
    end

    context "with a number that does not fit the step" do
      before { input.set_value("7") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be a step of 2, the nearest valid values are 6 and 8") }
    end
  end

  it_should_behave_like "a field that allows the required attribute" do
    let(:markup_with_required) { %{<input type="number" id="field" name="field" required />} }
    let(:markup_without_required) { %{<input type="number" id="field" name="field" />} }
    let(:valid_value) { "8" }
  end
end
