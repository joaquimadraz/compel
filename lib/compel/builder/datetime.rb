module Compel
  module Builder

    class DateTime < Schema

      def initialize
        super(Coercion::DateTime)
      end

      def format(value)
        options[:format] = value
        self
      end

      def iso8601
        options[:format] = '%FT%T'
        self
      end

    end

  end
end