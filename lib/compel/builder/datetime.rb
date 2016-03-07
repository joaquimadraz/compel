module Compel
  module Builder

    class DateTime < Schema

      include CommonValue

      def initialize
        super(Coercion::DateTime)
      end

      def format(value, options = {})
        build_option :format, value, options
      end

      def iso8601(options = {})
        build_option :format, '%FT%T', options
      end

    end

  end
end
