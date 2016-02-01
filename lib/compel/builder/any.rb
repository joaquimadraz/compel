module Compel
  module Builder

    class Any < Schema

      def initialize
        super(Coercion::Any)
      end

      def if(lambda = nil, &block)
        options[:if] = \
          if lambda && lambda.is_a?(Proc) && lambda.arity == 1
            lambda
          elsif block && block.arity == 0 && (block.call.is_a?(::Symbol) || block.call.is_a?(::String))
            block
          end

        fail if options[:if].nil?

        self
        rescue
          raise Compel::TypeError, 'invalid proc for if'
      end

    end

  end
end
