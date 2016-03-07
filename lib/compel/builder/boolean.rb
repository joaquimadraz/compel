module Compel
  module Builder

    class Boolean < Schema

      def initialize
        super(Coercion::Boolean)
      end

      def is(value)
        Coercion.coerce!(value, Coercion::Boolean)

        build_option :is, value
      end

    end

  end
end
