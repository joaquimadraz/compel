Compel
==========================
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
