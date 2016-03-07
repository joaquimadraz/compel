module Compel
  module Builder

    class Date < Schema

      include CommonValue

      def initialize
        super(Coercion::Date)
      end

      def format(value)
        build_option :format, value
      end

      def iso8601
        build_option :format, '%Y-%m-%d'
      end

    end

  end
end
