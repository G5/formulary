require 'spec_helper'

describe Formulary::HtmlForm::Fields::RangeInput do
  let(:html_form) { Formulary::HtmlForm.new(markup) }

  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::RangeInput.compatible_with?(element) }
    let(:markup) { %{<input type="#{type}" name="name" />} }

    context "range type" do
      let(:type) { "range" }
      it { should be_true }
    end

    context "email type" do
      let(:type) { "email" }
      it { should be_false }
    end
  end
end
