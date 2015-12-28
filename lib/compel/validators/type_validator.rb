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

          # if it is an array, we still need the above validations to check if
          # our array is valid before validate each value.
          # 'two bunnies with only one cajadada'
          if schema.type == Coercion::Array && errors.empty?
            validate_array_values(value)
          end
        rescue Compel::TypeError => exception
          @errors = [exception.message]
        end

        self
      end

      def validate_array_values(values)
        result = Result.new \
          ArrayValidator.new(values, schema).validate

        @output = result.value

        if !result.valid?
          # TODO: ArrayValidator should do this for me:
          # remove invalid coerced index,
          # and set the original value
          result.errors.keys.each do |index|
            @output[index.to_i] = values[index.to_i]
          end

          @errors = result.errors
        end
      end

      alias_method :serialize, :output
      alias_method :serialize_errors, :errors

    end

  end
end
