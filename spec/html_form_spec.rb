require 'spec_helper'

describe Formulary::HtmlForm do
  let(:markup) do
    <<-EOS
    <div class="lead widget">

      <p class="heading">Apply</p>

      <form id="lead_form" action="{{ widget.lead_form.submission_url.value }}" method="POST">

        <div class="field">
          <label for="first_name">First Name</label>
          <input type="text" name="first_name" required />
        </div>

        <div class="field">
          <label for="last_name">Last Name</label>
          <input type="text" name="last_name" required />
        </div>

        <div class="field">
          <label for="email">Email</label>
          <input type="email" name="email" required />
        </div>

        <div class="field">
          <label for="g5_email">G5 Email</label>
          <input type="email" name="g5_email" pattern="@getg5\.com$" />
        </div>

        <div class="field">
          <label for="phone">Phone</label>
          <input type="tel" name="phone" />
        </div>

        <div class="field">
          <label for="street_address">Street Address</label>
          <input type="text" name="street_address" />
        </div>

        <div class="field">
          <label for="city">City</label>
          <input type="text" name="city" pattern="^[A-Za-z]*$" />
        </div>

        <div class="field">
          <label for="state">State</label>
          <input type="text" name="state" />
        </div>

        <div class="field">
          <label for="zip">Zip</label>
          <input type="text" name="zip" />
        </div>

        <div class="field">
          <label for="message">Message</label>
          <textarea name="message"></textarea>
        </div>

        <div class="field">
          <label for="unit">Unit</label>
          <select name="unit">
            <option>5x5</option>
            <option value="5x10">Five By Ten</option>
          </select>
        </div>

        <input type="submit" value="Apply" />

        <input type="hidden" name="syndication_url" value="example.com" />

      </form>
    </div>
    EOS
  end

  def valid_params(hash = {})
    {
      first_name: "First",
      last_name: "Last",
      email: "test@test.com",
      g5_email: "test@getg5.com",
      unit: "5x5"
    }.merge(hash)
  end

  let(:html_form) { Formulary::HtmlForm.new(markup) }

  describe "#fields" do
    let(:fields) { html_form.fields }
    subject { fields }

    its(:length) { should eq(12) }

    describe "a required text input" do
      subject { fields.first }

      its(:name) { should eq("first_name") }
      its(:type) { should eq("text") }
      its(:required) { should be_true }
    end

    describe "a hidden input that is not required" do
      subject { fields[9] }

      its(:name) { should eq("syndication_url") }
      its(:type) { should eq("hidden") }
      its(:required) { should be_false }
    end

    describe "a textarea that is not required" do
      subject { fields[10] }

      its(:name) { should eq("message") }
      its(:type) { should eq("textarea") }
      its(:required) { should be_false }
    end

    describe "an input with a pattern attribute" do
      subject { fields[6] }

      its(:pattern) { should eq("^[A-Za-z]*$") }
    end

    describe "a select field" do
      subject { fields[11] }

      its(:name) { should eq("unit") }
      its(:type) { should eq("select") }
      its(:required) { should be_false }
    end
  end

  describe "#valid?" do
    subject(:valid) { html_form.valid?(params) }

    context "with valid parameters" do
      let(:params) { valid_params }
      it { should be_true }
    end

    context "with valid parameters" do
      context "phone number" do
        let(:params) { valid_params(phone: "+1 456 123987") }
        it { should be_true }
      end

      context "using text in a valueless option" do
        let(:params) { valid_params(unit: "5x5") }
        it { should be_true }
      end

      context "using text from an option with a value" do
        let(:params) { valid_params(unit: "5x10") }
        it { should be_true }
      end
    end

    context "with invalid parameters" do
      context "due to missing parameters" do
        let(:params) { { last_name: "" } }

        it { should be_false }

        it "has an error for an omitted field" do
          html_form.errors.keys.should include("first_name")
          html_form.errors["first_name"].should include("required")
        end

        it "has an error for a blank field" do
          html_form.errors.keys.should include("last_name")
          html_form.errors["last_name"].should include("required")
        end
      end

      context "due to missing hidden field" do
        let(:params) { { last_name: "" } }

        it { should be_false }

        it "has an error for an omitted field" do
          html_form.errors.keys.should include("first_name")
          html_form.errors["first_name"].should include("required")
        end

        it "has an error for a blank field" do
          html_form.errors.keys.should include("last_name")
          html_form.errors["last_name"].should include("required")
        end
      end

      context "due to failing regex check" do
        let(:params) { valid_params(city: "New York") }

        it { should be_false }

        it "has an error for the field that doesn't match the pattern" do
          valid
          html_form.errors.keys.should include("city")
          html_form.errors["city"].should include("format")
        end
      end

      context "due to invalid email address" do
        let(:params) { valid_params(email: "testing") }

        it { should be_false }

        it "has an error for the email field" do
          valid
          html_form.errors.keys.should include("email")
          html_form.errors["email"].should include("not a valid email")
        end
      end

      context "due to invalid g5 email address" do
        let(:params) { valid_params(g5_email: "test@test.com") }

        it { should be_false }

        it "has an error for the g5 email field" do
          valid
          html_form.errors.keys.should include("g5_email")
          html_form.errors["g5_email"].should include("format")
        end
      end

      context "due to unexpected parameters" do
        let(:params) { valid_params(extra: "test") }

        it "raises a Formulary::UnexpectedParameter exception" do
          expect { valid }.to raise_error(Formulary::UnexpectedParameter, /extra/)
        end
      end

      context "due to a unexpected option for a select" do
        let(:params) { valid_params(unit: "wrong") }

        it { should be_false }

        it "has an error for the select field" do
          valid
          html_form.errors.keys.should include("unit")
          html_form.errors["unit"].should include("choose")
        end
      end
    end
  end
end
