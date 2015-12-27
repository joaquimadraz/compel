module Compel
  module Builder

    class Boolean < Schema

      def initialize
        super(Coercion::Boolean)
      end

    end

  end
end
