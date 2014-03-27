require 'spec_helper'

describe Formulary::HtmlForm do
  context "with a form with complex validations" do
    let(:markup) do
      <<-EOS
      <div class="lead widget">

        <p class="heading">Apply</p>

        <form id="lead_form" action="{{ widget.lead_form.submission_url.value }}" method="POST">

          <div class="field">
            <label for="first_name">First Name</label>
            <input type="text" id="first_name" name="first_name" required />
          </div>

          <div class="field">
            <input type="text" name="last_name" required />
          </div>

          <div class="field">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required />
          </div>

          <div class="field">
            <label for="company_email">G5 Email</label>
            <input type="email" id="company_email" name="g5_email" pattern="@getg5\.com$" />
          </div>

          <div class="field">
            <label for="phone">Phone</label>
            <input type="tel" name="phone" />
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

          <fieldset>
            <legend>What is your favorite grease?</legend>
            <label><input type="radio" name="foods" value="bacon">Bacon</label>
            <label><input type="radio" name="foods" value="butter" checked>Butter</label>
          </fieldset>

          <input type="radio" name="beverages" value="water">Water<br>

          <label for="date">Date</label>
          <input type="date" id="date" name="date" />

          <input type="hidden" name="syndication_url" value="example.com" />

          <label>
            <input type="checkbox" name="terms">I accept your terms
          </label>

          <div class="field">
            <label for="labeless_field"></label>
            <input type="email" id="labeless_field" name="labeless_field" />
          </div>

          <div class="field">
            <label for="number">Number</label>
            <input type="number" name="number" id="number" min="5" />
          </div>

          <div class="field">
            <label for="range">Range</label>
            <input type="range" name="range" id="range" step="5" />
          </div>

          <div class="field">
            <label for="search">Search</label>
            <input type="search" name="search" id="search" />
          </div>

          <div class="field">
            <label for="password">Password</label>
            <input type="password" name="password" id="password" />
          </div>

          <div class="field">
            <label for="color">Color</label>
            <input type="color" name="color" id="color" />
          </div>

          <input type="submit" value="Submit" />
          <input type="button" value="Button" />
          <input type="image" value="Image" />
          <input type="reset" value="Reset" />
        </form>
      </div>
      EOS
    end

    let(:html_form) { Formulary::HtmlForm.new(markup) }

    context "unsupported field type" do
      let(:markup) { %{<input type="bacon" name="delicious" />} }

      it "explodes" do
        expect { html_form }.to raise_error(Formulary::UnsupportedFieldType, /bacon/)
      end
    end

    context "with a mismatch of field types for a group" do
      let(:markup) do
        %{
          <input type="radio" name="bacon" />
          <input type="checkbox" name="bacon" />
        }
      end

      it "explodes" do
        expect { html_form }.to raise_error(Formulary::UnsupportedFieldType, /bacon/)
      end
    end

    describe "validations" do
      let(:valid_params) do
        {
          first_name: "First",
          last_name: "Last",
          email: "test@test.com",
          g5_email: "test@getg5.com",
          unit: "5x5"
        }
      end

      describe "#valid?" do
        subject(:valid) { html_form.valid?(params) }

        context "with a valid submission" do
          let(:params) { valid_params }
          it { should be_true }
        end

        context "with an invalid submission" do
          let(:params) { {} }
          it { should be_false }
        end

        context "due to unexpected parameters" do
          let(:params) { valid_params.merge(extra: "test") }

          it "raises a Formulary::UnexpectedParameter exception" do
            expect { valid }.to raise_error(Formulary::UnexpectedParameter, /extra/)
          end
        end
      end

      describe "#errors" do
        before { html_form.valid?(params) }
        subject { html_form.errors }

        context "with a valid submission" do
          let(:params) { valid_params }
          it { should be_empty }
        end

        context "with an invalid submission" do
          let(:params) do
            {
              email: "invalid",
              g5_email: "test@example.com",
              foods: "water",
              date: "4 score and 7 years ago",
              number: "1",
              range: "8"
            }
          end

          its(["first_name"]) { should eql("'First Name' is required") }
          its(["email"]) { should include("'Email' is not a valid email address") }
          its(["g5_email"]) { should include("'G5 Email' does not match the expected format") }
          its(["foods"]) { should include("'What is your favorite grease?' must be chosen from the available options") }
          its(["date"]) { should include("'Date' is not a properly formatted date") }
          its(["number"]) { should include("'Number' must be greater than or equal to 5") }
          its(["range"]) { should include("'Range' must be a step of 5, the nearest valid values are 5 and 10") }
        end
      end
    end

    describe "#label_for_field" do
      subject { html_form.label_for_field(field_name) }

      context "with a label with a for attribute" do
        let(:field_name) { "first_name" }
        it { should eq("First Name") }
      end

      context "with no matching label" do
        let(:field_name) { "last_name" }
        it { should be_nil }
      end

      context "with a label with no text" do
        let(:field_name) { "labeless_field" }
        it { should eq("") }
      end

      context "with a parent label" do
        let(:field_name) { "terms" }
        it { should eq("I accept your terms") }
      end

      context "with a name and id mismatch on the field" do
        let(:field_name) { "g5_email" }
        it { should eq("G5 Email") }
      end

      context "with a fieldset" do
        let(:field_name) { "foods" }
        its(["fieldset"]) { should eq("What is your favorite grease?") }
        its(["bacon"]) { should eq("Bacon") }
        its(["butter"]) { should eq("Butter") }
      end
    end
  end

  context "with a form with nested fields" do
    let(:markup) do
      <<-EOS
        <form id="lead_form" action="{{ widget.lead_form.submission_url.value }}" method="POST">

          <label for="first_name">First Name</label>
          <input type="text" name="first_name" required />

          <label for="parent[child]">Nested Field</label>
          <input type="text" name="parent[child]" required />

          <input type="submit" value="Apply" />
        </form>
      EOS
    end

    subject(:valid) { Formulary::HtmlForm.new(markup).valid?(params) }

    context "with valid nested parameters" do
      let(:params) do
        { "first_name" => "Test", "parent" => { "child" => "nested value" } }
      end

      it { should be_true }
    end

    context "with invalid nested parameters" do
      let(:params) { { "parent" => { "invalid" => "bad" } } }

      it " explodes violently" do
        expect { valid }.to raise_error(Formulary::UnexpectedParameter, /invalid/)
      end
    end
  end
end
