require 'spec_helper'

describe Formulary::HtmlForm::Fields::WeekInput do
  let(:markup_with_label) { "<label for='field'>Field</label>#{markup}" }
  let(:html_form) { Formulary::HtmlForm.new(markup_with_label) }

  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::WeekInput.compatible_with?(element) }
    let(:markup) { %{<input type="#{type}" name="name" />} }

    context "text type" do
      let(:type) { "text" }
      it { should be_false }
    end

    context "week type" do
      let(:type) { "week" }
      it { should be_true }
    end
  end

  it_should_behave_like "a field that allows the required attribute" do
    let(:markup_with_required) { %{<input type="week" id="field" name="field" required />} }
    let(:markup_without_required) { %{<input type="week" id="field" name="field" />} }
    let(:valid_value) { "2014-W01" }
  end

  describe "validations" do
    subject(:input) { Formulary::HtmlForm::Fields::WeekInput.new(html_form, element) }
    let(:markup) { %{<input type="week" id="field" name="test" min="2013-W01" max="2014-W52" />} }

    context "with a valid week" do
      before { input.set_value("2014-W01") }

      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "with a invalid week" do
      before { input.set_value("1/44") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' is not a properly formatted week, please use YYYY-W##") }
    end

    context "with a week less than the min" do
      before { input.set_value("2012-W01") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be a week after 2013-W01") }
    end

    context "with a week greater than the max" do
      before { input.set_value("2015-W01") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be a week before 2014-W52") }
    end
  end
end
