module Compel
  module Validators

    class Base

      attr_reader :input,
                  :output,
                  :errors,
                  :schema

      def initialize(input, schema)
        @input = input.nil? ? schema.default_value : input
        @schema = schema
        @output = nil
        @errors = []
      end

      def valid?
        @errors.empty?
      end

      def self.validate(input, schema)
        new(input, schema).validate
      end

    end

  end
end

require 'compel/validators/type_validator'
require 'compel/validators/hash_validator'
require 'compel/validators/array_validator'
