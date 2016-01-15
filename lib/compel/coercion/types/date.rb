module Compel
  module Coercion

    class Date < DateType

      def klass
        ::Date
      end

      def default_format
         '%Y-%m-%d'
      end

    end

  end
end
