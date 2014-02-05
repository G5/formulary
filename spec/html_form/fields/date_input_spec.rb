require 'spec_helper'

describe Formulary::HtmlForm::Fields::DateInput do
  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::DateInput.compatible_with?(element) }
    let(:markup) { %{<input type="#{type}" name="name" />} }

    context "text type" do
      let(:type) { "text" }
      it { should be_false }
    end

    context "date type" do
      let(:type) { "date" }
      it { should be_true }
    end
  end

  it_should_behave_like "a field that allows the required attribute" do
    let(:markup_with_required) { %{<input type="date" name="field" required />} }
    let(:markup_without_required) { %{<input type="date" name="field" />} }
    let(:valid_value) { "2014-01-01" }
  end

  describe "validations" do
    subject(:input) { Formulary::HtmlForm::Fields::DateInput.new(element) }
    let(:markup) { %{<input type="date" name="test" />} }

    context "with a valid date" do
      before { input.set_value("2014-01-01") }

      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "with a invalid date" do
      before { input.set_value("1/5/11") }

      it { should_not be_valid }
      its(:error) { should include("date") }
      its(:error) { should include("yyyy-mm-dd") }
    end
  end
end
