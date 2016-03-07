module Compel
  module Builder

    class Time < Schema

      include CommonValue

      def initialize
        super(Coercion::Time)
      end

      def format(value)
        build_option :format, value
      end

      def iso8601
        build_option :format, '%FT%T'
      end

    end

  end
end
