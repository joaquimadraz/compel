module Compel
  module Coercion

    class Time < Type

      def coerce!
        format = options[:format] || '%FT%T'

        ::Time.strptime(value, format)

        rescue
          raise \
            Compel::TypeError,
            "'#{value}' is not a parsable time with format: #{format}"
      end

    end

  end
end
