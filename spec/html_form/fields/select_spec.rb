require 'spec_helper'

describe Formulary::HtmlForm::Fields::Select do
  let(:markup_with_label) { "<label for='field'>Field</label>#{markup}" }
  let(:html_form) { Formulary::HtmlForm.new(markup_with_label) }

  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::Select.compatible_with?(element) }

    context "with a select" do
      let(:markup) { %{<select name="field"></select>} }
      it { should be_true }
    end

    context "with a textarea" do
      let(:markup) { %{<textarea name="field"></textarea>} }
      it { should be_false }
    end

    context "with an input type" do
      let(:markup) { %{<input type="text" name="field" />} }
      it { should be_false }
    end
  end

  describe "validations" do
    subject(:input) { Formulary::HtmlForm::Fields::Select.new(html_form, element) }
    let(:markup) do
      <<-EOS
        <select id="field" name="field">
          <option>First Text</option>
          <option value="second_value">Second Text</option>
        </select>
      EOS
    end

    context "passed the text from a valueless option" do
      before { input.set_value("First Text") }

      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "passed the value from an option with a value" do
      before { input.set_value("second_value") }

      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "passed the text from a value with an option" do
      before { input.set_value("Second Text") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be chosen from the available options") }
    end

    context "passed a value that is not in the options" do
      before { input.set_value("unknown") }

      it { should_not be_valid }
      its(:error) { should eql("'Field' must be chosen from the available options") }
    end
  end
end
