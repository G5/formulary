require 'spec_helper'

describe Formulary::HtmlForm::Fields::TelInput do
  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::TelInput.compatible_with?(element) }
    let(:markup) { %{<input type="#{type}" name="name" />} }

    context "text type" do
      let(:type) { "text" }
      it { should be_false }
    end

    context "tel type" do
      let(:type) { "tel" }
      it { should be_true }
    end
  end

  it_should_behave_like "a field that allows the required attribute" do
    let(:markup_with_required) { %{<input type="tel" name="field" required />} }
    let(:markup_without_required) { %{<input type="tel" name="field" />} }
    let(:valid_value) { "123-123-1234" }
  end

  it_should_behave_like "a field that allows the pattern attribute" do
    let(:markup) { '<input type="tel" name="field" pattern="\d{3}-\d{3}-\d{4}" />' }
    let(:valid_value) { "123-123-1234" }
  end
end
