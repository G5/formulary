require 'spec_helper'

describe Formulary::HtmlForm::Fields::DateInput do
  let(:markup_with_label) { "<label for='field'>Field</label>#{markup}" }
  let(:html_form) { Formulary::HtmlForm.new(markup_with_label) }

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
    let(:markup_with_required) { %{<input type="date" id="field" name="field" required />} }
    let(:markup_without_required) { %{<input type="date" id="field" name="field" />} }
    let(:valid_value) { "2014-01-01" }
  end

  describe "validations" do
    subject(:input) { Formulary::HtmlForm::Fields::DateInput.new(html_form, element) }
    let(:markup) { %{<input type="date" id="field" name="test" min="2013-12-31" max="2014-02-01" />} }

    context "with a valid date" do
      before { input.set_value("2014-01-01") }

      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "with a invalid date" do
      before { input.set_value("1/5/14") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' is not a properly formatted date, please use YYYY-MM-DD") }
    end

    context "with a date less than the min" do
      before { input.set_value("2013-01-01") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be a date after 2013-12-31") }
    end

    context "with a date greater than the max" do
      before { input.set_value("2015-01-01") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be a date before 2014-02-01") }
    end
  end
end
