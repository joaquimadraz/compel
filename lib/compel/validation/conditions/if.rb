# encoding: UTF-8

module Compel
  module Validation

    class If < Condition

      def validate_value
        unless valid?
          "is invalid"
        end
      end

      private

      def valid?
        CustomValidator.new(option_value).valid?(value)
      end

    end

    class CustomValidator

      attr_reader :caller,
                  :method

      def initialize(caller)
        ❨╯°□°❩╯︵┻━┻? caller
      end

      def valid?(value)
        caller.send(method, value)
      end

      private

      def ❨╯°□°❩╯︵┻━┻? caller
        fail unless caller.is_a?(Proc) || caller.arity > 1

        if caller.arity == 1
          @caller = caller
          @method = 'call'
        else
          @caller = caller.binding.receiver
          @method = caller.call
        end
      end

    end

  end
end
