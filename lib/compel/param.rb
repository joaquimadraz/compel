module Compel

  class Param

    attr_reader :name,
                :type,
                :value,
                :options,
                :conditions

    def initialize(name, type, value, options = {}, &conditions)
      @name = name
      @type = type
      @value = value
      @options = options
      @conditions = conditions
    end

    def required?
      !!@options[:required]
    end

    def hash?
      @type == Hash
    end

    def conditions?
      !!@conditions
    end

  end

end