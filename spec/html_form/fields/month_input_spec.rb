require 'spec_helper'

describe Formulary::HtmlForm::Fields::MonthInput do
  let(:markup_with_label) { "<label for='field'>Field</label>#{markup}" }
  let(:html_form) { Formulary::HtmlForm.new(markup_with_label) }

  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::MonthInput.compatible_with?(element) }
    let(:markup) { %{<input type="#{type}" name="name" />} }

    context "text type" do
      let(:type) { "text" }
      it { should be_false }
    end

    context "month type" do
      let(:type) { "month" }
      it { should be_true }
    end
  end

  it_should_behave_like "a field that allows the required attribute" do
    let(:markup_with_required) { %{<input type="month" id="field" name="field" required />} }
    let(:markup_without_required) { %{<input type="month" id="field" name="field" />} }
    let(:valid_value) { "2014-01-01" }
  end

  describe "validations" do
    subject(:input) { Formulary::HtmlForm::Fields::MonthInput.new(html_form, element) }
    let(:markup) { %{<input type="month" id="field" name="test" min="2013-11" max="2014-02" />} }

    context "with a valid month" do
      before { input.set_value("2014-01") }

      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "with a invalid month" do
      before { input.set_value("1/14") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' is not a properly formatted month, please use YYYY-MM") }
    end

    context "with a month less than the min" do
      before { input.set_value("2013-01-01") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be a month after 2013-11") }
    end

    context "with a month greater than the max" do
      before { input.set_value("2015-01") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be a month before 2014-02") }
    end
  end
end
