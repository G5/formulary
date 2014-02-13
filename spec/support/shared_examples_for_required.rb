shared_examples_for "a field that allows the required attribute" do
  let(:markup_with_label) { "<label for='field'>Field</label>#{markup}" }
  let(:html_form) { Formulary::HtmlForm.new(markup_with_label) }
  subject(:input) { described_class.new(html_form, element) }

  context "required" do
    let(:markup) { markup_with_required }

    context "with a submitted value" do
      before { input.set_value(valid_value) }
      it { should be_valid }
      its(:error) { should be_blank }
    end

    context "submitted a blank value" do
      before { input.set_value("") }
      it { should_not be_valid }
      its(:error) { should include("required") }
    end

    context "submitted a nil value" do
      before { input.set_value(nil) }
      it { should_not be_valid }
      its(:error) { should eql("'Field' is required") }
    end
  end

  context "not required" do
    let(:markup) { markup_without_required }

    context "without a submitted value" do
      before { input.set_value("") }
      it { should be_valid }
      its(:error) { should be_blank }
    end
  end
end
