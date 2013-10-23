# Formulary

> <strong>Formularies</strong> (singular <strong>formulary</strong>; Latin <em>littera(e) formularis, -ares</em>) are medieval collections of models for the execution of documents (acta), public or private; a space being left for the insertion of names, dates, and circumstances peculiar to each case. Their modern equivalent are forms.
>
> -- <cite><a href="http://en.wikipedia.org/wiki/Formulary_%28model_documents%29">Wikipedia</a></cite> 

## Installation

Add this line to your application's Gemfile:

    gem 'formulary'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install formulary

## Usage

Create a new Formulary Form
    
```ruby
require 'formulary'

form_html = <<EOF
<form>
  <input type="email" name="email" required />
  <input type="username" name="username" pattern="[a-z0-9_-]{3,16}" />
</form>
EOF
  
html_form = Formulary::HtmlForm.new(form_html)
```

Validate the form based on HTML5 field types and/or patterns and view which fields are invalid and why.
    
```ruby
html_form.valid?({ email: "test@example.com", username: "person" })
# => true

html_form.valid?({ email: "invalid", username: "person" })
# => false

html_form.errors
# => {"email"=>"not a valid email"}
```

When an unexpected field is submitted that wasn't in the original markup, it will raise a `Formulary::UnexpectedParameter` exception:

```ruby
html_form.valid?({ unknown: "value" })
# => Formulary::UnexpectedParameter: Got unexpected field 'unknown'
```

## Currently Supported

- type="email"
- required
- pattern="REGEX"

## TODO

- select, checkbox, radio and multiselect tags have one of the valid options selected
- validate [other html5 field types](http://www.w3schools.com/html/html5_form_input_types.asp)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
