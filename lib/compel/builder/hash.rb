module Compel
  module Builder

    class Hash < Schema

      def initialize
        super(Coercion::Hash)

        options[:keys] = { value: {} }
      end

      def keys(object)
        build_option :keys, coerce_keys_schemas(object)

        self
      end

      private

      def coerce_keys_schemas(object)
        begin
          fail if object.nil?

          Coercion.coerce!(object, Coercion::Hash)
        rescue
          raise TypeError, 'Builder::Hash keys must be an Hash'
        end

        unless object.values.all?{|value| value.is_a?(Builder::Schema) }
          raise TypeError, 'All Builder::Hash keys must be a valid Schema'
        end

        object
      end

    end

  end
end
