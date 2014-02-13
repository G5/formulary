require 'spec_helper'

describe Formulary::HtmlForm::Fields::HiddenInput do
  let(:html_form) { Formulary::HtmlForm.new(markup) }

  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::HiddenInput.compatible_with?(element) }
    let(:markup) { %{<input type="#{type}" name="name" />} }

    context "text type" do
      let(:type) { "text" }
      it { should be_false }
    end

    context "hidden type" do
      let(:type) { "hidden" }
      it { should be_true }
    end
  end

  describe "validations" do
    subject(:input) { Formulary::HtmlForm::Fields::HiddenInput.new(html_form, element) }
    let(:markup) { %{<input type="hidden" name="field"></input>} }

    context "passed a value" do
      before { input.set_value("test") }

      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "passed no value" do
      before { input.set_value("") }

      it { should be_valid }
      its(:error) { should be_blank }
    end
  end
end
