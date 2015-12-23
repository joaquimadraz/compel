Compel 
==========================
![](https://travis-ci.org/joaquimadraz/compel.svg)
[![Code Climate](https://codeclimate.com/github/joaquimadraz/compel/badges/gpa.svg)](https://codeclimate.com/github/joaquimadraz/compel)

Ruby Hash Coercion and Validation

This is a straight forward way to validate a Ruby Hash: just give your object and the schema to validate.
Based on the same principle from [Grape](https://github.com/ruby-grape/grape) framework and [sinatra-param](https://github.com/mattt/sinatra-param) gem to validate request params.

There are 3 ways run validations:

- `#run`  
  - Validates and return an Hash with coerced params plus a `:errors` key with an Hash of errors if any.
- `#run!`
  - Validates and raises `Compel::InvalidParamsError` exception the coerced params and generated errors.
- `#run?`
  - Validates and returns true or false.

### Example
```ruby
Compel.run({ first_name: 'Joaquim', birth_date: '1989-0' }) do
  param :first_name, String, required: true
  param :last_name, String, required: true
  param :birth_date, DateTime
end
```

Will return:

```ruby
{
  first_name: 'Joaquim,
  errors: {
    last_name: ['is required'],
    brith_date: ["'1989-0' is not a valid DateTime"]
  }
}
```
