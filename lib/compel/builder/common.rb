module Compel
  module Builder

    module Common

      def is(value)
        options[:is] = value
        self
      end

      def blank
        options[:blank] = true
        self
      end

      def length(value)
        options[:length] = Coercion.coerce!(value, ::Integer)
        self
      end

      def required
        options[:required] = true
        self
      end

    end

  end
end
