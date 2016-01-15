module Compel
  module Coercion

    class DateTime < DateType

      def klass
        ::DateTime
      end

      def default_format
        '%FT%T'
      end

    end

  end
end
