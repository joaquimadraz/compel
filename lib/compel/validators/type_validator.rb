# Validates a type, given an input, type and options
# output is a coerced value
# error is an array of strings
module Compel
  module Validators

    class TypeValidator < Base

      def validate
        if !schema.required? && input.nil?
          return self
        end

        options = input, schema.type, schema.options

        # coerce
        coercion_result = Coercion.coerce(*options)

        unless coercion_result.valid?
          @errors = [coercion_result.error]
          return self
        end

        @output = coercion_result.coerced

        # validate
        @errors = Validation.validate(*options)

        # validate array values
        if schema.type == Coercion::Array && errors.empty?
          validate_array_values(input)
        end

        self
      end

      def validate_array_values(values)
        result = Result.new \
          ArrayValidator.validate(values, schema)

        @output = result.value

        if !result.valid?
          # TODO: ArrayValidator should do this for me:
          # remove invalid coerced index,
          # and set the original value.
          # If it's an Hash, keep errors key
          result.errors.keys.each do |index|
            if @output[index.to_i].is_a?(Hash)
              # Keep errors key on hash if exists
              @output[index.to_i].merge!(values[index.to_i])
            else
              # Array, Integer, String, Float, Dates.. etc
              @output[index.to_i] = values[index.to_i]
            end
          end

          @errors = result.errors
        end
      end

      alias_method :serialize, :output
      alias_method :serialize_errors, :errors

    end

  end
end
