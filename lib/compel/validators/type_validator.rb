# Validates a type, given an input, type and options
# output is a coerced value
# error is an array of strings
module Compel
  module Validators

    class TypeValidator < Base

      def initialize(input, schema)
        super
        @output = nil
      end

      def validate
        value = input.nil? ? schema.default_value : input

        begin
          @output = Coercion.coerce!(value, schema.type, schema.options)
          @errors = Validation.validate(value, schema.type, schema.options)
        rescue Compel::TypeError => exception
          @errors = [exception.message]
        end

        self
      end

    end

  end
end
