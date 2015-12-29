# Validates values of an hash recursively
# output is an hash with coerced values
# errors is a Compel::Errors

# This is not beauty,
# but it's tested and working.
module Compel
  module Validators

    class HashValidator < Base

      attr_reader :keys_schemas

      def initialize(input, schema)
        super
        @errors = Errors.new

        @keys_schemas = schema.options[:keys]
      end

      def validate
        if schema.required? || !input.nil?
          hash_type_validator = TypeValidator.new(input, schema).validate

          # validate hash before validate its keys
          if !hash_type_validator.valid?
            @output = input
            errors.add(:base, hash_type_validator.errors)
            return self
          end

          @input = Hashie::Mash.new(input)
          @output = Hashie::Mash.new

          keys_schemas.keys.each do |param_name|

            if (input[param_name].is_a?(Hash))
              hash_validator = \
                HashValidator.new(input[param_name], keys_schemas[param_name])
                  .validate

              errors.add(param_name, hash_validator.errors)
              output[param_name] = hash_validator.output
            end

            type_validator = \
              TypeValidator.new(output[param_name].nil? ? input[param_name] : output[param_name], keys_schemas[param_name])
                .validate

            if !type_validator.output.nil?
              output[param_name] = type_validator.output
            end

            if !type_validator.valid?
              errors.add(param_name, type_validator.errors)
            end
          end
        end

        self
      end

      def serialize
        coerced = input.is_a?(Hash) ?  input.merge(output) : Hashie::Mash.new

        coerced.tap do |hash|
          if !errors.empty?
            hash[:errors] = serialize_errors
          end
        end
      end

      def serialize_errors
        errors.to_hash
      end

    end

  end
end
