module Compel
  module Coercion

    class Time < DateType

      def klass
        ::Time
      end

      def default_format
        '%FT%T'
      end

    end

  end
end
