require 'json'
require 'hashie'
require 'hashie/extensions/symbolize_keys'

require 'compel/coercion/type'
require 'compel/coercion/integer'
require 'compel/coercion/float'
require 'compel/coercion/string'
require 'compel/coercion/date'
require 'compel/coercion/time'
require 'compel/coercion/datetime'
require 'compel/coercion/hash'
require 'compel/coercion/json'
require 'compel/coercion/boolean'

require 'compel/invalid_params_error'
require 'compel/param_validation_error'
require 'compel/param_type_error'

require 'compel/validators/base'
require 'compel/validators/type_validator'
require 'compel/validators/hash_validator'

require 'compel/builder/methods'
require 'compel/contract'
require 'compel/coercion'
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
    Contract.new(params, schema).validate.serialize
  end

end
