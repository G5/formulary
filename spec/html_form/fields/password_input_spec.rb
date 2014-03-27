require 'spec_helper'

describe Formulary::HtmlForm::Fields::PasswordInput do
  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::PasswordInput.compatible_with?(element) }
    let(:markup) { %{<input type="#{type}" name="name" />} }

    context "password type" do
      let(:type) { "password" }
      it { should be_true }
    end

    context "text type" do
      let(:type) { "text" }
      it { should be_false }
    end
  end

  it_should_behave_like "a field that allows the required attribute" do
    let(:markup_with_required) { %{<input type="password" id="field" name="field" required />} }
    let(:markup_without_required) { %{<input type="password" id="field" name="field" />} }
    let(:valid_value) { "test" }
  end

  it_should_behave_like "a field that allows the pattern attribute" do
    let(:markup) { %{<input type="password" id="field" name="field" pattern="^test$" />} }
    let(:valid_value) { "test" }
  end
end
