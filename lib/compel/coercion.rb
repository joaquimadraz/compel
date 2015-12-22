module Compel

  module Coercion

    def valid?(value, type, options = {})
      !!coerce!(value, type, options) rescue false
    end

    def coerce!(value, type, options = {})
      # most of this code snippet is from sinatra-param gem
      # https://github.com/mattt/sinatra-param
      # by Mattt Thompson (@mattt)
      begin
        return nil if value.nil?
        return value if (value.is_a?(type) rescue false)
        return Integer(value) if type == Integer
        return Float(value) if type == Float
        return String(value) if type == String
        return Date.parse(value) if type == Date
        return Time.parse(value) if type == Time
        return DateTime.parse(value) if type == DateTime
        return JSON.parse(value) if type == JSON
        return (/(false|f|no|n|0)$/i === value.to_s ? false : (/(true|t|yes|y|1)$/i === value.to_s ? true : nil)) if type == TrueClass || type == FalseClass || type == Boolean
        fail
      rescue
        raise ParamTypeError, "'#{value}' is not a valid #{type}"
      end
    end

    extend self

  end

end
