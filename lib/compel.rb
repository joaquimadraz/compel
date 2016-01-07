require 'hashie'

require 'compel/exceptions/type_error'
require 'compel/exceptions/invalid_object_error'

require 'compel/validators/base'
require 'compel/builder/methods'
require 'compel/coercion/coercion'
require 'compel/validation/validation'

require 'compel/result'
require 'compel/errors'
require 'compel/contract'

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
