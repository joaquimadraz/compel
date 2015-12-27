module Compel
  module Builder

    class Float < Schema

      include CommonValue

      def initialize
        super(Coercion::Float)
      end

    end

  end
end
