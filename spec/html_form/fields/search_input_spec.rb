require 'spec_helper'

describe Formulary::HtmlForm::Fields::SearchInput do
  describe ".compatible_with?" do
    subject { Formulary::HtmlForm::Fields::SearchInput.compatible_with?(element) }
    let(:markup) { %{<input type="#{type}" name="name" />} }

    context "search type" do
      let(:type) { "search" }
      it { should be_true }
    end

    context "text type" do
      let(:type) { "text" }
      it { should be_false }
    end
  end
end
