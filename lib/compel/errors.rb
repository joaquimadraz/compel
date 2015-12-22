module Compel

  class Errors

    def initialize
      @errors = {}
    end

    def add(key, error)
      if error.is_a?(Compel::Errors)
        if error.empty?
          return
        end

        if @errors[key].nil?
          @errors[key] = {}
        end

        @errors[key].merge!(error.to_hash(true))

        return
      end

      if !error.is_a?(Array)
        error = [error]
      end

      if error.empty?
        return
      end

      if @errors[key].nil?
        @errors[key] = []
      end

      @errors[key].concat(error)
    end

    def length
      @errors.keys.length
    end

    def empty?
      length == 0
    end

    def to_hash(stringify_keys = false)
      if stringify_keys
        return @errors
      end

      Hashie.symbolize_keys(@errors)
    end

  end

end
