require 'spec_helper'

describe Formulary::HtmlForm::Fields::Field do
  let(:html_form) { Formulary::HtmlForm.new(markup) }
  let(:field) { Formulary::HtmlForm::Fields::Field.new(html_form, element) }

  describe "#name" do
    subject { field.name }
    let(:markup) { %{<input type="text" name="field" />} }

    it { should eq("field") }
  end

  describe "#label" do
    subject { field.label }

    context "when the there is no label" do
      let(:markup) { %{<input type="text" name="field" />} }
      it { should be_nil }
    end

    context "when the label is from a singular field" do
      let(:markup) do
        %{
          <label for="field">Field</label>
          <input type="text" id="field" name="field" />
        }
      end
      it { should eql("Field") }
    end

    context "when the label is for a field group" do
      let(:markup) do
        %{
          <fieldset>
            <legend>Field</legend>
            <label>
              <input type="checkbox" name="field" value="first">
            </label>
            <label>
              <input type="checkbox" name="field" value="second">
            </label>
          </fieldset>
        }
      end
      it { should eql("Field") }
    end
  end
end
