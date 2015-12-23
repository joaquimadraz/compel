module Compel

  module Coercion

    def valid?(value, type, options = {})
      !!coerce!(value, type, options) rescue false
    end

    def coerce!(value, type, options = {})
      return nil if value.nil?

      begin
        klass = compel_type?(type) ? type : get_compel_type_klass(type)

        return klass.new(value, options).coerce!
      rescue
        raise ParamTypeError, "'#{value}' is not a valid #{type}"
      end
    end

    def compel_type?(type)
      type.to_s.split('::')[0..1].join('::') == 'Compel::Coercion'
    end

    def get_compel_type_klass(type)
      const_get("Compel::Coercion::#{type}")
    end

    extend self

  end

end
