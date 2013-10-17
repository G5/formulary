require 'spec_helper'

describe HtmlForm do
  let(:markup) do
    <<-EOS
    <div class="lead widget">

      <p class="heading">Apply</p>

      <form id="lead_form" action="{{ widget.lead_form.submission_url.value }}" method="POST">

        <div class="field">
          <label for="first_name">First Name</label>
          <input type="text" name="lead[first_name]" id="first_name" required />
        </div>

        <div class="field">
          <label for="last_name">Last Name</label>
          <input type="text" name="lead[last_name]" id="last_name" required />
        </div>

        <div class="field">
          <label for="email">Email</label>
          <input type="email" name="lead[email]" id="email" required />
        </div>

        <div class="field">
          <label for="phone">Phone</label>
          <input type="tel" name="lead[phone]" id="phone" />
        </div>

        <div class="field">
          <label for="street_address">Street Address</label>
          <input type="text" name="lead[street_address]" id="street_address" />
        </div>

        <div class="field">
          <label for="city">City</label>
          <input type="text" name="lead[city]" id="city" pattern="^[A-Za-z]*$" />
        </div>

        <div class="field">
          <label for="state">State</label>
          <input type="text" name="lead[state]" id="state" />
        </div>

        <div class="field">
          <label for="zip">Zip</label>
          <input type="text" name="lead[zip]" id="zip" />
        </div>

        <div class="field">
          <label for="message">Message</label>
          <textarea name="lead[message]" id="message"></textarea>
        </div>

        <input type="submit" value="Apply" />

      </form>
    </div>
    EOS
  end

  let(:html_form) { HtmlForm.new(markup) }

  describe "#fields" do
    let(:fields) { html_form.fields }
    subject { fields }

    its(:length) { should eq(9) }

    describe "a required text input" do
      subject { fields.first }

      its(:name) { should eq("first_name") }
      its(:type) { should eq("text") }
      its(:required) { should be_true }
    end

    describe "a textarea that is not required" do
      subject { fields[8] }

      its(:name) { should eq("message") }
      its(:type) { should eq("textarea") }
      its(:required) { should be_false }
    end

    describe "an input with a pattern attribute" do
      subject { fields[5] }

      its(:pattern) { should eq("^[A-Za-z]*$") }
    end
  end

  describe "#valid?" do
    subject { html_form.valid?(params) }
    before { subject }

    context "with valid parameters" do
      let(:params) do
        {
          first_name: "First",
          last_name: "Last",
          email: "test@example.com"
        }
      end

      it { should be_true }
    end

    context "with invalid parameters" do
      context "due to missing parameters" do
        let(:params) { { last_name: "" } }

        it { should be_false }

        it "has an error for an omitted field" do
          html_form.errors.keys.should include("first_name")
          html_form.errors["first_name"].should match(/required/)
        end

        it "has an error for a blank field" do
          html_form.errors.keys.should include("last_name")
          html_form.errors["last_name"].should match(/required/)
        end
      end

      context "due to failing regex check" do
        let(:params) { { city: "New York" } }

        it "has an error for the field that doesn't match the pattern" do
          html_form.errors.keys.should include("city")
          html_form.errors["city"].should match(/format/)
        end
      end
    end
  end
end
