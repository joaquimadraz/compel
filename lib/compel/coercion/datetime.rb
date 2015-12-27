module Compel
  module Coercion

    class DateTime < Type

      def coerce!
        format = options[:format] || '%FT%T'

        ::DateTime.strptime(value, format)

        rescue
          raise \
            Compel::TypeError,
            "'#{value}' is not a parsable datetime with format: #{format}"
      end

    end

  end
end
