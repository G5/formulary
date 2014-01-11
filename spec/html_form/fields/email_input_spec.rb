require 'spec_helper'

describe Formulary::HtmlForm::Fields::EmailInput do
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
    let(:markup_with_required) { %{<input type="email" name="field" required />} }
    let(:markup_without_required) { %{<input type="email" name="field" />} }
    let(:valid_value) { "test@example.com" }
  end

  it_should_behave_like "a field that allows the pattern attribute" do
    let(:markup) { '<input type="email" name="field" pattern="@example\.com$" />' }
    let(:valid_value) { "test@example.com" }
  end

  describe "validations" do
    subject(:input) { Formulary::HtmlForm::Fields::EmailInput.new(element) }
    let(:markup) { %{<input type="email" name="name" />} }

    context "with a valid email address" do
      before { input.set_value("test@example.com") }

      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "with an invalid email address" do
      before { input.set_value("invalid!") }

      it { should_not be_valid }
      its(:error) { should include("email") }
    end

    context "with a nil email address" do
      before { input.set_value(nil) }

      it { should be_valid }
      its(:error) { should be_blank }
    end
  end
end
