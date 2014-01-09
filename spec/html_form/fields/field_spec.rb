require 'spec_helper'

describe Formulary::HtmlForm::Fields::Field do
  describe "#name" do
    subject { Formulary::HtmlForm::Fields::Field.new(element).name }
    let(:markup) { %{<input type="text" name="field" />} }

    it { should eq("field") }
  end
end
