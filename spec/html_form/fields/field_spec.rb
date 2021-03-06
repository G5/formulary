require 'spec_helper'

module Formulary::HtmlForm::Fields
  class SomeInput < Input; end
end

describe Formulary::HtmlForm::Fields::Field do
  let(:markup) { %{<input type="text" name="field" />} }
  let(:html_form) { Formulary::HtmlForm.new(markup) }
  let(:field) { Formulary::HtmlForm::Fields::Field.new(html_form, element) }

  describe "#name" do
    subject { field.name }

    it { should eq("field") }
  end

  describe "#get_value_from_data_field" do
    let(:data_field) {"data-hide-from-email"}
    subject {field.get_value_from_data_field(data_field)}
    it {should be_nil}

    context "@element is set(normal fields)" do
      let(:markup) { %{<input type="text" name="field" data-hide-from-email="true"/>} }
      it {should eql("true")}
    end

    context "@elements is set (checkbox or radio button)" do
      let(:markup){ %{<input type="checkbox" name="super" data-hide-from-email="foo">
                      <input type="checkbox" name="duper" data-hide-from-email="bar">}}
      it {should eql("foo")}
    end

    context "@element is nil" do
      let(:markup){""}
      it {should be_nil}
    end
  end

  describe "#label" do
    subject { field.label }

    context "when the there is no label" do
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

  describe "#is_hidden?" do
    subject { field.is_hidden? }

    context "hidden" do
      let(:field) { Formulary::HtmlForm::Fields::HiddenInput.new(html_form, element) }
      it { should be_true }
    end

    context "not hidden" do
      let(:field) { Formulary::HtmlForm::Fields::TextInput.new(html_form, element) }
      it { should be_false }
    end

    describe "field without compatible_type defined" do
      let(:field) { Formulary::HtmlForm::Fields::SomeInput.new(html_form, element) }
      it { should be_false }
    end
  end
end
