require 'json'
require 'hashie'
require 'hashie/extensions/symbolize_keys'

require 'compel/exceptions/invalid_object_error'
require 'compel/exceptions/validation_error'
require 'compel/exceptions/type_error'

require 'compel/result'

require 'compel/validators/base'
require 'compel/validators/type_validator'
require 'compel/validators/hash_validator'
require 'compel/validators/array_validator'

require 'compel/builder/methods'
require 'compel/coercion/coercion'
require 'compel/contract'
require 'compel/validation'
require 'compel/errors'

module Compel

  extend Builder::Methods

  def self.run!(params, schema)
    Contract.new(params, schema).validate.raise?
  end

  def self.run?(params, schema)
    Contract.new(params, schema).validate.valid?
  end

  def self.run(params, schema)
    Contract.new(params, schema).validate
  end

end
