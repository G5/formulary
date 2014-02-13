require 'spec_helper'

describe Formulary::HtmlForm::Fields::RadioButtonGroup do
  let(:markup_with_label) do
    "<fieldset><legend>Field</legend>#{markup}</fieldset>"
  end
  let(:html_form) { Formulary::HtmlForm.new(markup_with_label) }

  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::RadioButtonGroup.compatible_with?(elements) }

    context "with checkboxen" do
      let(:markup) do
        %{
          <input type="checkbox" name="field" value="one">
          <input type="checkbox" name="field" value="two">
        }
      end

      it { should be_false }
    end

    context "with radio buttons" do
      let(:markup) do
        %{
          <input type="radio" name="field" value="one">
          <input type="radio" name="field" value="two">
        }
      end

      it { should be_true }
    end

    context "with a sweet mix of the two" do
      let(:markup) do
        %{
          <input type="checkbox" name="field" value="one">
          <input type="radio" name="field" value="two">
        }
      end

      it { should be_false }
    end
  end

  describe "validations" do
    subject(:radio_group) do
      Formulary::HtmlForm::Fields::RadioButtonGroup.new(html_form, "food", elements)
    end

    context "when one of the items in the group is required" do
      let(:markup) do
        %{
          <label>
            Bacon<input type="radio" name="food" value="bacon" required />
          </label>
          <label>
            Butter<input type="radio" name="food" value="butter" />
          </label>
        }
      end

      context "with a valid submission" do
        before { radio_group.set_value("bacon") }
        it { should be_valid }
        its(:error) { should be_blank }
      end

      context "with a value that isn't expected" do
        before { radio_group.set_value("eggplant") }
        it { should_not be_valid }
        its(:error) { should eql("'Field' must be chosen from the available options") }
      end

      context "with no value" do
        before { radio_group.set_value("") }
        it { should_not be_valid }
        its(:error) { should eql("'Field' is required") }
      end
    end

    context "when none are required" do
      let(:markup) do
        %{
          <label>
            <input type="radio" name="food" value="bacon" />
          </label>
          <label>
            <input type="radio" name="food" value="butter" />
          </label>
        }
      end

      context "with a value that isn't expected" do
        before { radio_group.set_value("eggplant") }
        it { should_not be_valid }
        its(:error) { should eql("'Field' must be chosen from the available options") }
      end

      context "with no value" do
        before { radio_group.set_value("") }
        it { should be_valid }
        its(:error) { should be_blank }
      end

      context "with nil value" do
        before { radio_group.set_value(nil) }
        it { should be_valid }
        its(:error) { should be_blank }
      end
    end
  end
end
