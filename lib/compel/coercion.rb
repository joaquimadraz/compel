module Compel

  module Coercion

    def valid?(value, type, options = {})
      !!coerce!(value, type, options) rescue false
    end

    def coerce!(value, type, options = {})
      return nil if value.nil?

      begin
        coercion_klass(type).new(value, options).coerce!
      rescue Compel::TypeError => exception
        raise exception
      rescue
        type_split = "#{type}".split('::')

        raise Compel::TypeError, "'#{value}' is not a valid #{type_split[-1]}"
      end
    end

    def coercion_klass(type)
      Compel::Coercion.const_get("#{type}")
    end

    extend self

  end

end
