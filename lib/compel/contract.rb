module Compel

  class Contract

    attr_reader :object, :schema

    def initialize(object, schema)
      @object = object
      @schema = schema
    end

    def validate
      Result.new(setup!.validate)
    end

    private

    def setup!
      are_we_good?

      validator_klass.new(object, schema)
    end

    def validator_klass
      if schema.type == Coercion::Hash
        Validators::HashValidator
      elsif schema.type == Coercion::Array
        Validators::ArrayValidator
      else
        Validators::TypeValidator
      end
    end

    def are_we_good?
      if schema.type == Coercion::Hash &&
        (object.nil? || !Coercion.valid?(object, Hash))
        raise Compel::TypeError, 'object to validate must be an Hash'
      end

      if schema.type == Coercion::Array &&
        (object.nil? || !Coercion.valid?(object, Array))
        raise Compel::TypeError, 'object to validate must be an Array'
      end
    end

  end

end
