module Compel
  module Coercion

    class Type

      attr_accessor :value,
                    :options

      def initialize(value, options = {})
        @value = value
        @options = options
      end

      def parse
        @value = value
      end

      def serialize
        raise '#serialize? should be implemented'
      end

      def coerce!
        parse
        coerce
      end

    end

  end
end
