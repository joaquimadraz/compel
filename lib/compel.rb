require 'json'
require 'hashie'
require 'hashie/extensions/symbolize_keys'

require 'compel/invalid_params_error'
require 'compel/param_validation_error'
require 'compel/param_type_error'

require 'compel/param'
require 'compel/contract'
require 'compel/coercion'
require 'compel/validation'
require 'compel/errors'

module Compel

  Boolean = :boolean

  def self.compel!(params, &block)
    Contract.new(params, &block).validate.raise?
  end

  def self.compel?(params, &block)
    Contract.new(params, &block).validate.valid?
  end

  def self.compel(params, &block)
    Contract.new(params, &block).validate.serialize
  end

end
