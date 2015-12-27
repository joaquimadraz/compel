module Compel

  class Contract

    attr_reader :errors,
                :serialized_errors

    def initialize(hash, schema)
      if hash.nil? || !Coercion.valid?(hash, Hash)
        raise TypeError, 'must be an Hash'
      end

      @hash = Hashie::Mash.new(hash)
      @schema = schema
      @coerced_hash = Hashie::Mash.new
    end

    def validate
      validator = Validators::HashValidator.new(@hash, @schema).validate

      @errors = validator.errors
      @coerced_hash = validator.output

      self
    end

    def coerced_hash
      # @hash has all params that are not affected by the validation
      @hash.merge(@coerced_hash)
    end

    def serialize
      coerced_hash.tap do |hash|
        if !valid?
          hash[:errors] = serialized_errors
        end
      end
    end

    def valid?
      @errors.empty?
    end

    def serialized_errors
      @errors.to_hash
    end

    def raise?
      if !valid?
        exception = InvalidHashError.new
        exception.params = coerced_hash
        exception.errors = serialized_errors

        raise exception, 'params are invalid'
      end

      coerced_hash
    end

  end

end
