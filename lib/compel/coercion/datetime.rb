module Compel
  module Coercion

    class DateTime < Type

      def coerce!
        format = options[:format] || '%FT%T'

        if value.is_a?(::DateTime)
          @value = value.strftime(format)
        end

        coerced = ::DateTime.strptime(value, format)

        if coerced.strftime(format) == value
          return coerced
        end

        fail

        rescue
          raise \
            Compel::TypeError,
            "'#{value}' is not a parsable datetime with format: #{format}"
      end

    end

  end
end
