module Compel
  module Builder

    class DateTime < Schema

      def initialize
        super(Coercion::DateTime)
      end

    end

  end
end
