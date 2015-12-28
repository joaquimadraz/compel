# Validates values of an hash recursively
# output is an hash with coerced values
# errors is a Compel::Errors

# This is not beauty,
# but it's tested and working.
module Compel
  module Validators

    class HashValidator < Base

      def initialize(input, schema)
        super
        @input = Hashie::Mash.new(input)
        @output = Hashie::Mash.new
        @errors = Errors.new

        @keys_schemas = schema.options[:keys]
      end

      def validate
        @keys_schemas.keys.each do |param_name|

          if (@input[param_name].is_a?(Hash))
            hash_validator = \
              HashValidator.new(@input[param_name], @keys_schemas[param_name])
                .validate

            @errors.add(param_name, hash_validator.errors)
            @output[param_name] = hash_validator.output
          end

          type_validator = \
            TypeValidator.new(@output[param_name].nil? ? @input[param_name] : @output[param_name], @keys_schemas[param_name])
              .validate

          if !type_validator.output.nil?
            @output[param_name] = type_validator.output
          end

          if !type_validator.valid?
            @errors.add(param_name, type_validator.errors)
          end
        end

        self
      end

      def serialize
        coerced = @input.merge(@output)

        coerced.tap do |hash|
          if !@errors.empty?
            hash[:errors] = serialize_errors
          end
        end
      end

      def serialize_errors
        @errors.to_hash
      end

    end

  end
end
