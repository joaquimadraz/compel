module Compel
  module Builder

    module CommonValue

      def in(value)
        options[:in] = value
        self
      end

      def range(value)
        options[:range] = value
        self
      end

      def min(value)
        options[:min] = value
        self
      end

      def max(value)
        options[:max] = value
        self
      end

    end

  end
end
