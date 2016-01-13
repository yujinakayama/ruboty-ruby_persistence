require 'ruboty'

module Ruboty
  module Handlers
    class RubyPersistence < Base
      NAMESPACE = 'ruby_persistence'.freeze

      on(
        /ruby-define (?<name>.+?) (?<code>.+)/m,
        description: 'Define persisted Ruby variable',
        name: 'define',
      )

      on(
        /ruby-undefine (?<name>.+)/m,
        description: 'Undefine persisted Ruby variable',
        name: 'undefine',
      )

      def initialize(*)
        super
        restore
      end

      def define(message)
        name = message[:name]

        if !variables.key?(name) && (method = predefined_method(name))
          message.reply("Error: `#{name}` is predefined by `#{method.owner}`")
        else
          define_and_persist_variable(message)
        end
      end

      def undefine(message)
        name = message[:name]

        if variables[name]
          undefine_variable(name)
          variables.delete(name)
          message.reply("`#{name}` is now undefined")
        else
          message.reply("Error: No such variable `#{name}`")
        end
      end

      private

      def restore
        variables.each do |name, value|
          define_variable(name, value)
        end
      end

      def predefined_method(name)
        context.method(name)
      rescue NameError
        nil
      end

      def define_and_persist_variable(message)
        name = message[:name]
        value = context.instance_eval(message[:code])
        define_variable(name, value)
        variables[name] = value
        message.reply("`#{name}` is now `#{value.inspect}`")
      rescue Exception => exception
        message.reply("#{exception.class}: #{exception}")
      end

      def define_variable(name, value)
        context.__send__(:define_method, name) { value }
      end

      def undefine_variable(name)
        context.singleton_class.__send__(:undef_method, name)
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
