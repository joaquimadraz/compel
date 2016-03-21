module Compel
  module Builder

    class Time < Schema

      include CommonValue

      def initialize
        super(Coercion::Time)
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
