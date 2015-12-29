module Compel
  module Builder

    class Array < Schema

      def initialize
        super(Coercion::Array)
      end

      def items(schema)
        if !schema.is_a?(Schema)
          raise Compel::TypeError, '#items must be a valid Schema'
        end

        options[:items] = schema
        self
      end

      def is(value)
        options[:is] = Coercion.coerce!(value, ::Array)
        self
      end

      def validate(object)
        Contract.new(object, self).validate
      end

    end

  end
end
