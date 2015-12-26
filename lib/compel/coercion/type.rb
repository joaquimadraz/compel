module Compel
  module Coercion

    class Type

      attr_accessor :value,
                    :options

      def initialize(value, options = {})
        @value = value
        @options = options
      end

    end

  end
end
