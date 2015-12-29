require 'compel/coercion/types/type'
require 'compel/coercion/types/integer'
require 'compel/coercion/types/float'
require 'compel/coercion/types/string'
require 'compel/coercion/types/date'
require 'compel/coercion/types/time'
require 'compel/coercion/types/datetime'
require 'compel/coercion/types/hash'
require 'compel/coercion/types/json'
require 'compel/coercion/types/boolean'
require 'compel/coercion/types/regexp'
require 'compel/coercion/types/array'

require 'compel/coercion/result'
require 'compel/coercion/nil_result'

module Compel

  module Coercion

    def valid?(value, type, options = {})
      coerce(value, type, options).valid?
    end

    def coerce!(value, type, options = {})
      result = coerce(value, type, options)

      unless result.valid?
        raise Compel::TypeError, result.error
      end

      result.coerced
    end

    def coerce(value, type, options = {})
      return NilResult.new if value.nil?

      coercion_klass = Compel::Coercion.const_get("#{type}")

      coercion_klass.new(value, options).coerce
    end

    extend self

  end

end
