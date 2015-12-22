module Compel

  class Coercion

    attr_reader :errors

    def initialize(params, contract)
      @errors = Errors.new
      @params = params
      @contract = contract
    end

    def run
      @params.each do |param, value|
        begin
          Coercion.coerce(value, @contract[param][:type], @contract[param][:options])
        rescue Compel::InvalidParameterError => exception
          @errors.add(param, exception.message)
        end
      end

      @errors
    end

    def self.valid?(value, type, options = {})
      begin
        coerce(value, type, options)
        true
      rescue Compel::InvalidParameterError
        false
      end
    end

    # from sinatra-param, give kudos
    def self.coerce(value, type, options = {})
      begin
        return nil if value.nil?
        return value if (value.is_a?(type) rescue false)
        return Integer(value) if type == Integer
        return Float(value) if type == Float
        return String(value) if type == String
        return Date.parse(value) if type == Date
        return Time.parse(value) if type == Time
        return DateTime.parse(value) if type == DateTime
        return Array(value.split(options[:delimiter] || ",")) if type == Array
        return Hash[value.split(options[:delimiter] || ",").map{|c| c.split(options[:separator] || ":")}] if type == Hash
        return (/(false|f|no|n|0)$/i === value.to_s ? false : (/(true|t|yes|y|1)$/i === value.to_s ? true : nil)) if type == TrueClass || type == FalseClass || type == Boolean
        return nil
      rescue
        raise InvalidParameterError, "'#{value}' is not a valid #{type}"
      end
    end

  end

end
