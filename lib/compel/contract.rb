module Compel

  class Contract

    attr_reader :errors,
                :conditions,
                :serialized_errors

    def initialize(params, &block)
      if params.nil? || !Coercion.valid?(params, Hash)
        raise ParamTypeError, 'Compel params must be an Hash'
      end

      @errors = Errors.new
      @params = Hashie::Mash.new(params)
      @conditions = Hashie::Mash.new

      instance_eval(&block)
    end

    def validate
      @conditions.values.each do |param|
        begin
          # If it is an Hash and it was given conditions for that Hash,
          # build a new Compel::Contract form inner conditions
          if (param.hash? && param.conditions?)

            # If this param is required, build the Compel::Contract,
            # otherwise, only build it if is given a value for the param
            if param.required? || !param.value.nil?
              contract = Contract.new(param.value, &param.conditions).validate

              @errors.add(param.name, contract.errors)
            end
          end

          # All values must coerce before going through validation,
          # raise exception to avoid validation
          Coercion.coerce!(param.value, param.type, param.options)

          @errors.add param.name, Validation.validate(param.value, param.options)

        rescue Compel::ParamTypeError => exception
          @errors.add(param.name, exception.message)
        end
      end

      self
    end

    def param(name, type, options = {}, &block)
      @conditions[name] = \
        Param.new(name, type, @params[name], options, &block)
    end

    def serialized_errors
      @errors.to_hash
    end

    def valid?
      @errors.empty?
    end

    def raise?
      if !valid?
        exception = InvalidParamsError.new
        exception.errors = serialized_errors

        raise exception, 'params are invalid'
      end
    end

  end

end
