Compel 
==========================
![](https://travis-ci.org/joaquimadraz/compel.svg)
[![Code Climate](https://codeclimate.com/github/joaquimadraz/compel/badges/gpa.svg)](https://codeclimate.com/github/joaquimadraz/compel)

Ruby Hash Coercion and Validation

This is a straight forward way to validate a Ruby Hash: just give an object and the schema.

The motivation was to create an integration for [RestMyCase](https://github.com/goncalvesjoao/rest_my_case) and have validations before any business logic execution.

Based on the same principle from [Grape](https://github.com/ruby-grape/grape) framework and [sinatra-param](https://github.com/mattt/sinatra-param) gem to validate request params.

### Example

```ruby
params= {
  first_name: 'Joaquim',
  birth_date: '1989-0',
  address: {
    line_one: 'Lisboa',
    post_code: '1100',
    country: 'PT'
  }
}

Compel.run(params) do
  param :first_name, String, required: true
  param :last_name, String, required: true
  param :birth_date, DateTime
  param :address, Hash do
    param :line_one, String, required: true
    param :line_two, String, default: '-'
    param :post_code, String, required: true, format: /^\d{4}-\d{3}$/
    param :country_code, String, in: ['PT', 'GB'], default: 'PT'
  end
end
```

Will return an [Hashie::Mash](https://github.com/intridea/hashie) object:

```ruby
{
  "first_name" => "Joaquim",
  "address" => {
    "line_one" => "Lisboa", 
    "line_two" => "-", # default value
    "post_code_pfx" => 1100, # Already an Integer
    "country_code"=> "PT"
  },
  "errors" => {
    "last_name" => ["is required"],
    "birth_date" => ["'1989-0' is not a valid DateTime"],
    "address" => {
      "post_code_sfx" => ["is required"]
    }
  }
}
```

There are 3 ways to run validations:

Method  | Behaviour
------------- | -------------
`#run`  | Validates and returns an Hash with coerced params plus a `:errors` key with a _Rails like_ Hash of errors if any.
`#run!` | Validates and raises `Compel::InvalidParamsError` exception with the coerced params and errors.
`#run?` | Validates and returns true or false.

### Types

- `Integer`
- `Float`
- `String`
- `JSON`
  - ex: `"{\"a\":1,\"b\":2,\"c\":3}"`
- `Hash`
  - ex: `{ a: 1,  b: 2, c: 3 }`
- `Date`
- `Time`
- `DateTime`
- `Compel::Boolean`, 
  - ex: `1`/`0`, `true`/`false`, `t`/`f`, `yes`/`no`, `y`/`n`

### Sinatra Integration

If you want to use with `Sinatra`, just add the following code to your Sinatra app:

```ruby
class App < Sinatra::Base
  
  ...
  
  def compel(&block)
    Compel.run!(params, &block)
  end

  error Compel::InvalidParamsError do |exception|
    status 400
    json errors: exception.errors
  end
  
  configure :development do
    set :show_exceptions, false
    set :raise_errors, true
  end
  
  ...
  
  post '/api/posts' do
    compel do
      param :post, Hash, required: true do
        param :title, String, required: true
      end
    end
  
    puts params[:post]      
  end
  
  ...

end
```
###Installation

Add this line to your application's Gemfile:

    gem 'compel'

And then execute:

    $ bundle
    
### TODO

- Write more Documentation (check specs for now ;)
- Rails integration
- [RestMyCase](https://github.com/goncalvesjoao/rest_my_case) integration


### Get in touch
If you have any questions, write an issue or get in touch [@joaquimadraz](https://twitter.com/joaquimadraz)

