module Compel
  module Coercion

    class Time < Type

      def coerce!
        format = options[:format] || '%FT%T'

        if value.is_a?(::Time)
          @value = value.strftime(format)
        end

        coerced = ::Time.strptime(value, format)

        if coerced.strftime(format) == value
          return coerced
        end

        fail

        rescue
          raise \
            Compel::TypeError,
            "'#{value}' is not a parsable time with format: #{format}"
      end

    end

  end
end
