module Compel
  module Builder

    class DateTime < Schema

      include CommonValue

      def initialize
        super(Coercion::DateTime)
      end

      def format(value)
        build_option :format, value

        self
      end

      def iso8601
        build_option :format, '%FT%T'

        self
      end

    end

  end
end
