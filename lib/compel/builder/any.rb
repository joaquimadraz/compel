module Compel
  module Builder

    class Any < Schema

      def initialize
        super(Coercion::Any)
      end

    end

  end
end
