# Formulary

> <strong>Formularies</strong> (singular <strong>formulary</strong>; Latin <em>littera(e) formularis, -ares</em>) are medieval collections of models for the execution of documents (acta), public or private; a space being left for the insertion of names, dates, and circumstances peculiar to each case. Their modern equivalent are forms.
>
> -- <cite><a href="http://en.wikipedia.org/wiki/Formulary_%28model_documents%29">Wikipedia</a></cite> 

A Ruby gem to parse HTML5 forms and decompose them into model validation using their field types (email, url, number, etc) and form attributes (required, pattern, etc).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'formulary'
```

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

**Supported Input Types**
- checkbox
- color
- date
- email
- hidden
- month
- number
- password
- radio
- range
- search
- tel 
- text
- week

**Ignored Field Types (not validated but does not make things explode)
- button
- image
- reset
- submit

**Supported Input Attributes**
- max (number, range, date)
- min (number, range, date)
- pattern
- required
- step (number, range)

**Other Supported Tags**
- select
- textarea


## TODO

**Add Unsupported Input Types**
- datetime
- datetime-local
- file
- time
- url 

## Authors

        * Don Petersen / [@dpetersen](https://github.com/dpetersen)
        * Matt Bohme / [@quady](https://github.com/quady)


## Contributing

1. Fork it
2. Get it running (see Installation above)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Write your code and **specs**
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request


## License

        Copyright (c) 2013 G5

        MIT License

        Permission is hereby granted, free of charge, to any person obtaining
        a copy of this software and associated documentation files (the
                        "Software"), to deal in the Software without restriction, including
        without limitation the rights to use, copy, modify, merge, publish,
        distribute, sublicense, and/or sell copies of the Software, and to
        permit persons to whom the Software is furnished to do so, subject to
        the following conditions:

        The above copyright notice and this permission notice shall be
        included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
        EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
        MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
        NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
        LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
        OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
        WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

