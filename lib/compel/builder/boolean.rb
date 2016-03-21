module Compel
  module Builder

    class Boolean < Schema

      def initialize
        super(Coercion::Boolean)
      end

      def is(value, options = {})
        Coercion.coerce!(value, Coercion::Boolean)

        build_option :is, value, options
      end

    end

  end
end
