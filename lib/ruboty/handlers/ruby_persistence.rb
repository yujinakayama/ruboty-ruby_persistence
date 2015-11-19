require 'ruboty'

module Ruboty
  module Handlers
    class RubyPersistence < Base
      NAMESPACE = 'ruby_persistence'.freeze

      on(
        /ruby-set (?<name>.+?) (?<code>.+)/m,
        description: 'Set persisted Ruby variable',
        name: 'set',
      )

      on(
        /ruby-unset (?<name>)/m,
        description: 'Unset persisted Ruby variable',
        name: 'unset',
      )

      def set(message)
        name = message[:name]

        if variables[name]
          set_and_persist(message)
        elsif (method = predefined_method(name))
          message.reply("Error: `#{name}` is predefined by `#{method.owner}`")
        else
          set_and_persist(message)
        end
      end

      def unset(message)
        name = message[:name]

        if variables[name]
          variables.delete(name)
          message.reply("`#{name}` is now unset")
        else
          message.reply("Error: No such variable `#{name}`")
        end
      end

      private

      def predefined_method(name)
        context.method(name)
      rescue NameError
        nil
      end

      def set_and_persist(message)
        name = message[:name]
        result = eval(message[:code])
        context.define_method(name) { result }
        variables[name] = result
        message.reply("`#{name}` is now `#{result.to_inspect}`")
      rescue Exception => exception
        message.reply("#{exception.class}: #{exception}")
      end

      def variables
        robot.brain.data[NAMESPACE] ||= {}
      end

      def context
        ::Ruboty::RubyPersistence::MainContext
      end
    end
  end
end
