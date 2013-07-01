module Savon::Economic
  module ActiveRecord
    def economic options
      options = {name:options} unless options.is_a? Hash
      e_class = options[:class] || ['Savon','Economic', 'Model', options[:name].to_s.camelcase].join('::').constantize
      throw new Exception "Class #{self.name} already has included another Savon::Economic model" if self.included_modules.include? LocalMethods
      class_attribute :economic_class
      self.economic_class = e_class
      include LocalMethods
      throw new Exception "Class #{e_class} has been already included by another ActiveRecord model" if e_class.included_modules.include? RemoteMethods
      e_class.send :include, RemoteMethods
    end

    module LocalMethods
      extend ActiveSupport::Concern

      def remote
        @economic_instance ||= economic_class.new self
      end

      def economic_config
        self.class.economic_config
      end

      module ClassMethods
        def remote
          economic_class
        end

        def economic_config
          remote.config
        end
      end
    end

    module RemoteMethods
      def initialize local
        @local = local
        super()
      end

      def method_missing *args
        return @local.public_send(*args) if @local.respond_to? args[0]
        super
      end

      def respond_to? name
        @local.respond_to?(name) || super
      end
    end
  end
end