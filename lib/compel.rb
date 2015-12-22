require 'compel/no_resource_defined'
require 'compel/no_resource_definition'
require 'compel/resource_definition'

module Compel

  def self.compel?(params, &block)
    Contract.new(Hashie::Mash.new(params), &block)
      .coerce
      .validate
      .valid?
  end

  def self.compel(params, &block)
    Contract.new(Hashie::Mash.new(params), &block)
      .coerce
      .validate
      .errors
      .to_hash
  end

end
