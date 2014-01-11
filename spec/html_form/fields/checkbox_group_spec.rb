require 'spec_helper'

describe Formulary::HtmlForm::Fields::CheckboxGroup do
  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::CheckboxGroup.compatible_with?(elements) }

    context "with checkboxen" do
      let(:markup) do
        %{
          <input type="checkbox" name="field" value="one">
          <input type="checkbox" name="field" value="two">
        }
      end

      it { should be_true }
    end

    context "with radio buttons" do
      let(:markup) do
        %{
          <input type="radio" name="field" value="one">
          <input type="radio" name="field" value="two">
        }
      end

      it { should be_false }
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
    subject(:checkbox_group) do
      Formulary::HtmlForm::Fields::CheckboxGroup.new("food", elements)
    end

    context "when one of the items in the group is required" do
      let(:markup) do
        %{
          <input type="checkbox" name="field" value="first" required>
          <input type="checkbox" name="field" value="second">
        }
      end

      context "with the required item" do
        before { checkbox_group.set_value("first") }

        it { should be_valid }
        its(:error) { should be_blank }
      end

      context "with required and non-required items" do
        before { checkbox_group.set_value(["first","second"]) }

        it { should be_valid }
        its(:error) { should be_blank }
      end

      context "with a non-required item" do
        before { checkbox_group.set_value("second") }

        it { should_not be_valid }
        its(:error) { should include("required") }
      end

      context "with a value that isn't expected" do
        before { checkbox_group.set_value([ "first", "invalid" ]) }

        it { should_not be_valid }
        its(:error) { should include("choose") }
      end

      context "with no value" do
        it { should_not be_valid }
        its(:error) { should include("required") }
      end
    end

    context "when none are required" do
      let(:markup) do
        %{
          <input type="checkbox" name="field" value="first">
          <input type="checkbox" name="field" value="second">
        }
      end

      context "with a value that isn't expected" do
        before { checkbox_group.set_value("invalid") }

        it { should_not be_valid }
        its(:error) { should include("choose") }
      end

      context "with no value" do
        it { should be_valid }
        its(:error) { should be_blank }
      end

      context "passed 'on' when all values are specified" do
        before { checkbox_group.set_value("on") }

        it { should_not be_valid }
        its(:error) { should include("choose") }
      end
    end

    context "when no value is specified in the markup" do
      context "when it is required" do
        let(:markup) { %{<input type="checkbox" name="field" required>} }

        context "when it is checked" do
          before { checkbox_group.set_value("on") }

          it { should be_valid }
          its(:error) { should be_blank }
        end
      end

      context "when it is not required" do
        let(:markup) { %{<input type="checkbox" name="field">} }


        context "when it is checked" do
          before { checkbox_group.set_value("on") }

          it { should be_valid }
          its(:error) { should be_blank }
        end
      end
    end
  end
end
