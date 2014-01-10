require 'spec_helper'

describe Formulary::HtmlForm::Fields::RadioButtonGroup do
  describe "validations" do
    subject(:radio_group) { Formulary::HtmlForm::Fields::RadioButtonGroup.new("food", elements) }

    context "when one of the items in the group is required" do
      let(:markup) do
        %{<input type="radio" name="food" value="bacon" required />
        <input type="radio" name="food" value="butter" /> }
      end

      context "with a valid submission" do
        before { radio_group.set_value("bacon") }
        it { should be_valid }
        its(:error) { should be_blank }
      end

      context "with a value that isn't expected" do
        before { radio_group.set_value("eggplant") }
        it { should_not be_valid }
        its(:error) { should include("choose") }
      end

      context "with no value" do
        before { radio_group.set_value("") }
        it { should_not be_valid }
        its(:error) { should include("required") }
      end
    end

    context "when none are required" do
      let(:markup) do
        %{<input type="radio" name="food" value="bacon" />
        <input type="radio" name="food" value="butter" /> }
      end

      context "with a value that isn't expected" do
        before { radio_group.set_value("eggplant") }
        it { should_not be_valid }
        its(:error) { should include("choose") }
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
