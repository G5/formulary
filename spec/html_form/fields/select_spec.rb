require 'spec_helper'

describe Formulary::HtmlForm::Fields::Select do
  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::Select.compatible_with?(element) }

    context "with a select" do
      let(:markup) { %{<select name="name"></select>} }
      it { should be_true }
    end

    context "with a textarea" do
      let(:markup) { %{<textarea name="name"></textarea>} }
      it { should be_false }
    end

    context "with an input type" do
      let(:markup) { %{<input type="text" name="name" />} }
      it { should be_false }
    end
  end

  describe "validations" do
    subject(:input) { Formulary::HtmlForm::Fields::Select.new(element) }
    let(:markup) do
      <<-EOS
        <select name="name">
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
      its(:error) { should include("choose") }
    end

    context "passed a value that is not in the options" do
      before { input.set_value("unknown") }

      it { should_not be_valid }
      its(:error) { should include("choose") }
    end
  end
end
