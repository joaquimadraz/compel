module Compel
  module Builder

    class Boolean < Schema

      def initialize
        super(Coercion::Boolean)
      end

      def is(value)
        Coercion.coerce!(value, Coercion::Boolean)
        options[:is] = value

        self
      end

    end

  end
end
