module Compel
  module Validators

    class ArrayValidator < Base

      attr_reader :items_schema

      def initialize(input, schema)
        super

        @errors = Errors.new
        @output = []
        @items_schema = schema.options[:items]
      end

      def validate
        unless array_valid?
          return self
        end

        items_validator = \
          ArrayItemsValidator.validate(input, items_schema)

        @output = items_validator.output

        unless items_validator.valid?
          @errors = items_validator.errors
        end

        self
      end

      def serialize_errors
        @errors.to_hash
      end

      alias_method :serialize, :output

      private

      def array_valid?
        if !schema.required? && input.nil?
          return false
        end

        array_errors = []

        unless input.is_a?(Array)
          array_errors << "'#{input}' is not a valid Array"
        end

        array_errors += \
          Validation.validate(input, schema.type, schema.options)

        unless array_errors.empty?
          errors.add(:base, array_errors)
          return false
        end

        if items_schema.nil?
          return false
        end

        true
      end

    end

    class ArrayItemsValidator < Base

      def initialize(input, schema)
        super

        @output = []
        @errors = Errors.new
      end

      def validate
        input.each_with_index do |item, index|

          if !schema.required? && item.nil?
            next
          end

          item_validator = \
            if schema.type == Coercion::Hash
              HashValidator.validate(item, schema)
            else
              TypeValidator.validate(item, schema)
            end

          output << item_validator.serialize

          if !item_validator.valid?
            # added errors for the index of that invalid array value
            errors.add("#{index}", item_validator.serialize_errors)
          end
        end

        self
      end

    end

  end
end
