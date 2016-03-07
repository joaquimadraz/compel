module Compel
  module Builder

    class Array < Schema

      def initialize
        super(Coercion::Array)
      end

      def items(schema, options = {})
        if !schema.is_a?(Schema)
          raise Compel::TypeError, '#items must be a valid Schema'
        end

        build_option :items, schema, options
      end

      def is(value)
        build_option :is, Coercion.coerce!(value, Coercion::Array)
      end

    end

  end
end
