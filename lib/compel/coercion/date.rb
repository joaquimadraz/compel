module Compel
  module Coercion

    class Date < Type

      def coerce!
        format = options[:format] || '%Y-%m-%d'

        if value.is_a?(::Date)
          @value = value.strftime(format)
        end

        coerced = ::Date.strptime(value, format)

        if coerced.strftime(format) == value
          return coerced
        end

        fail

        rescue
          raise \
            Compel::TypeError,
            "'#{value}' is not a parsable date with format: #{format}"
      end

    end

  end
end
