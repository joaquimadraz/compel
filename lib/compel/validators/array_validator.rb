module Compel
  module Validators

    class ArrayValidator < Base

      attr_reader :items_schema

      def initialize(input, schema)
        super

        @output = []
        @errors = {}

        @items_schema = schema.options[:items]
      end

      def validate
        each_array_value do |item, index, items_validator|
          items_validator.validate

          @output << items_validator.serialize

          if !items_validator.valid?
            # added errors for the index of that invalid array value
            @errors["#{index}"] = items_validator.serialize_errors
          end
        end

        self
      end

      def each_array_value
        value = input.nil? ? schema.default_value : input

        value.each_with_index do |item, index|
          # ignore items that are nil unless they are required,
          # actually..this comment does not help
          if items_schema.required? || !item.nil?
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

      alias_method :serialize, :output
      alias_method :serialize_errors, :errors

    end

  end
end
