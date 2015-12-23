Compel 
==========================
![](https://travis-ci.org/joaquimadraz/compel.svg)
[![Code Climate](https://codeclimate.com/github/joaquimadraz/compel/badges/gpa.svg)](https://codeclimate.com/github/joaquimadraz/compel)

Ruby Hash Coercion and Validation


```ruby
Compel.compel({ first_name: 'Joaquim' }) do
  param :first_name, String, required: true
  param :last_name, String, required: true
  param :birth_date, DateTime
end
```

returns:

```ruby
{
  first_name: 'Joaquim,
  errors: {
    last_name: ['is required']
  }
}
```
