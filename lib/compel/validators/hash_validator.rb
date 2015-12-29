# Validates values of an hash recursively
# output is an hash with coerced values
# errors is a Compel::Errors
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
        unless root_hash_valid?
          return self
        end

        @input = Hashie::Mash.new(input)

        keys_validator = \
          HashKeysValidator.validate(input, keys_schemas)

        @errors = keys_validator.errors
        @output = keys_validator.output

        self
      end

      def serialize
        coerced = output.is_a?(Hash) ? input.merge(output) : Hashie::Mash.new

        coerced.tap do |hash|
          if !errors.empty?
            hash[:errors] = serialize_errors
          end
        end
      end

      def serialize_errors
        errors.to_hash
      end

      private

      def root_hash_valid?
        if !schema.required? && input.nil?
          return false
        end

        root_hash = TypeValidator.validate(input, schema)

        unless root_hash.valid?
          errors.add(:base, root_hash.errors)
          return false
        end

        true
      end

    end

    class HashKeysValidator < Base

      attr_reader :schemas

      def initialize(input, schemas)
        super

        @output = {}
        @errors = Errors.new
        @schemas = schemas
      end

      def validate
        schemas.keys.each do |key|
          value = output[key].nil? ? input[key] : output[key]

          validator = TypeValidator.validate(value, schemas[key])

          unless validator.output.nil?
            output[key] = validator.output
          end

          unless validator.valid?
            errors.add(key, validator.errors)
            next
          end

          if input[key].is_a?(Hash)
            hash_validator = HashValidator.validate(input[key], schemas[key])

            errors.add(key, hash_validator.errors)
            output[key] = hash_validator.output
          end

        end

        self
      end

    end

  end
end
