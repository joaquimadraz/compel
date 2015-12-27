module Compel
  module Builder

    module Common

      def is(value)
        options[:is] = value
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
