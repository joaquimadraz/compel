module Compel
  module Builder

    class Date < Schema

      include CommonValue

      def initialize
        super(Coercion::Date)
      end

      def format(value)
        options[:format] = value
        self
      end

      def iso8601
        options[:format] = '%Y-%m-%d'
        self
      end

    end

  end
end
