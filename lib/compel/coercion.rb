module Compel

  module Coercion

    def valid?(value, type, options = {})
      !!coerce!(value, type, options) rescue false
    end

    def coerce!(value, type, options = {})
      return nil if value.nil?

      begin
        coercion_klass(type).new(value, options).coerce!
      rescue
        raise ParamTypeError, "'#{value}' is not a valid #{type}"
      end
    end

    def coercion_klass(type)
      Compel::Coercion.const_get("#{type}")
    end

    extend self

  end

end
