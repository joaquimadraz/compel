module Compel
  module Coercion

    class Date < Type

      def coerce!
        format = options[:format] || '%Y-%m-%d'

        ::Date.strptime(value, format)

        rescue
          raise \
            Compel::TypeError,
            "'#{value}' is not a parsable date with format: #{format}"
      end

    end

  end
end
