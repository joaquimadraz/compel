module Compel
  module Builder

    module Common

      def length(value)
        options[:length] = Coercion.coerce!(value, ::Integer)
        self
      end

      def required
        options[:required] = true
        self
      end

      def default(value)
        options[:default] = value
        self
      end

    end

  end
end
