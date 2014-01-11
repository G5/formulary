shared_examples_for "a field that allows the pattern attribute" do
  subject(:input) { described_class.new(element) }

  context "with a matching value" do
    before { input.set_value(valid_value) }
    it { should be_valid }
    its(:error) { should be_blank }
  end

  context "without a matching value" do
    before { input.set_value("z") }
    it { should_not be_valid }
    its(:error) { should include("format") }
  end
end
