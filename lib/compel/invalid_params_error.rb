module Compel

  class InvalidParamsError < StandardError

    attr_accessor :params, :errors

  end

end
