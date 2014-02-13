require 'spec_helper'

describe Formulary::HtmlForm::Fields::Textarea do
  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::Textarea.compatible_with?(element) }

    context "with a textarea" do
      let(:markup) { %{<textarea name="name"></textarea>} }
      it { should be_true }
    end

    context "with a select" do
      let(:markup) { %{<select name="name"></select>} }
      it { should be_false }
    end

    context "with an input type" do
      let(:markup) { %{<input type="text" name="name" />} }
      it { should be_false }
    end
  end

  it_should_behave_like "a field that allows the required attribute" do
    let(:markup_with_required) { %{<textarea id="field" name="field" required></textarea>} }
    let(:markup_without_required) { %{<textarea id="field" name="field"></textarea>} }
    let(:valid_value) { "test" }
  end
end
