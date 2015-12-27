module Compel
  module Builder

    class String < Schema

      include CommonValue

      def initialize
        super(Coercion::String)
      end

      def format(regex)
        options[:format] = Coercion.coerce!(regex, ::Regexp)
        self
      end

    end

  end
end
