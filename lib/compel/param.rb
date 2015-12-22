module Compel

  class Param

    attr_reader :type,
                :options,
                :conditions

    def initialize(type, value, options = {}, &conditions)
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
