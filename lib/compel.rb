require 'json'
require 'hashie'
require 'hashie/extensions/symbolize_keys'

require 'compel/contract'
require 'compel/coercion'
require 'compel/validation'
require 'compel/errors'
require 'compel/invalid_parameter_error'

module Compel

  def self.compel?(params, &block)
    Contract.new(params, &block)
      .coerce
      .validate
      .valid?
  end

  def self.compel(params, &block)
    Contract.new(params, &block)
      .coerce
      .validate
      .errors
      .to_hash
  end

end
