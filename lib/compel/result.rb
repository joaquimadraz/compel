module Compel

  class Result

    attr_reader :value, :errors

    def initialize(validator)
      @valid = validator.valid?
      @value = validator.serialize
      @errors = validator.serialize_errors
    end

    def valid?
      @valid
    end

    def raise?
      if !valid?
        exception = InvalidHashError.new
        exception.object = value

        raise exception, 'hash has errors'
      end

      value
    end

  end

end
