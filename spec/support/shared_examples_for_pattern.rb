shared_examples_for "a field that allows the pattern attribute" do
  let(:markup_with_label) { "<label for='field'>Field</label>#{markup}" }
  let(:html_form) { Formulary::HtmlForm.new(markup_with_label) }
  subject(:input) { described_class.new(html_form, element) }

  context "with a matching value" do
    before { input.set_value(valid_value) }
    it { should be_valid }
    its(:error) { should be_blank }
  end

  context "without a matching value" do
    before { input.set_value("z") }
    it { should_not be_valid }
    its(:error) { should include("'Field' does not match the expected format") }
  end
end
