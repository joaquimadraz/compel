module Compel

  class Errors

    def initialize
      @errors = {}
    end

    def add(key, error)
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

    def merge(_errors)
      if _errors.is_a?(Compel::Errors)
        _errors = _errors.to_hash
      end

      if _errors.is_a?(Hash)
        @errors.merge!(_errors)
      end
    end

    def length
      @errors.keys.length
    end

    def empty?
      length == 0
    end

    def to_hash
      Hashie.symbolize_keys(@errors)
    end

  end

end
