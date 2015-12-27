module Compel
  module Builder

    class Integer < Schema

      include CommonValue

      def initialize
        super(Coercion::Integer)
      end

    end

  end
end
