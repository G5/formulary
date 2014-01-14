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

          <input type="radio" name="foods" value="bacon">Bacon<br>
          <input type="radio" name="foods" value="butter" checked>Butter<br>

          <input type="radio" name="beverages" value="water">Water<br>

          <input type="hidden" name="syndication_url" value="example.com" />

          <input type="checkbox" name="terms">

          <input type="submit" value="Apply" />
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
              email: "invalid", g5_email: "test@example.com", foods: "water"
            }
          end

          its(["first_name"]) { should include("required") }
          its(["email"]) { should include("email") }
          its(["g5_email"]) { should include("format") }
          its(["foods"]) { should include("choose") }
        end
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
