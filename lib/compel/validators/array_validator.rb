module Compel
  module Validators

    class ArrayValidator < Base

      attr_reader :items_schema

      def initialize(input, schema)
        super
        @errors = Errors.new
        @items_schema = schema.options[:items]
      end

      def validate
        if schema.required? || !input.nil?
          @output = []

          value_errors = []

          if !input.is_a?(Array)
            value_errors << "'#{input}' is not a valid Array"
          end

          value_errors += Validation.validate(input, schema.type, schema.options)

          if !value_errors.empty?
            errors.add(:base, value_errors)
            return self
          end

          each_array_value do |item, index, items_validator|
            items_validator.validate

            output << items_validator.serialize

            if !items_validator.valid?
              # added errors for the index of that invalid array value
              errors.add("#{index}", items_validator.serialize_errors)
            end
          end
        end

        self
      end

      def each_array_value
        input.each_with_index do |item, index|
          # ignore items that are nil unless they are required,
          # actually..this comment does not help
          if !items_schema.nil? && (items_schema.required? || !item.nil?)
            # we can talk about arrays of arrays later
            item_validator = \
              if items_schema.type == Coercion::Hash
                HashValidator.new(item, items_schema)
              else
                TypeValidator.new(item, items_schema)
              end

            # why am I doing this?
            yield(item, index, item_validator)
          end
        end
      end

      def serialize_errors
        @errors.to_hash
      end

      alias_method :serialize, :output

    end

  end
end
