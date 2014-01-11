require 'spec_helper'

describe Formulary::HtmlForm::Fields::Input do
  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::EmailInput.compatible_with?(element) }

    context "with a textarea" do
      let(:markup) { %{<textarea name="name"></textarea>} }
      it { should be_false }
    end

    context "with a select" do
      let(:markup) { %{<select name="name"></select>} }
      it { should be_false }
    end
  end
end
