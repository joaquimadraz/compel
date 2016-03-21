module Compel
  module Builder

    class Date < Schema

      include CommonValue

      def initialize
        super(Coercion::Date)
      end

      def format(value, options = {})
        build_option :format, value, options
      end

      def iso8601(options = {})
        build_option :format, '%Y-%m-%d', options
      end

    end

  end
end
