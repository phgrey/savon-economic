# Here we will our own Savon Model bc we do need:
# a) inherited client
# b) custom convert_request_keys_to

module Savon
  module Economic
    module Operations

      def client globals={}
        #we will have to convert theese tags ourselves
        globals[:convert_request_keys_to] = :none
        @@client ||= Savon::Client.new(globals)
      rescue Savon::InitializationError
        raise_initialization_error!
      end

      def global(option, *value)
        client.globals[option] = value
      end


      def raise_initialization_error!
        raise Savon::InitializationError,
              "Expected the model to be initialized with either a WSDL document or the SOAP endpoint and target namespace options.\n" \
              "Make sure to setup the model by calling the .client class method before calling the .global method.\n\n" \
              "client(wsdl: '/Users/me/project/service.wsdl')                              # to use a local WSDL document\n" \
              "client(wsdl: 'http://example.com?wsdl')                                     # to use a remote WSDL document\n" \
              "client(endpoint: 'http://example.com', namespace: 'http://v1.example.com')  # if you don't have a WSDL document"
      end

      # Accepts one or more SOAP operations and generates both class and instance methods named
      # after the given operations. Each generated method accepts an optional SOAP message Hash.
      def operations(*operations)
        operations.each do |operation|
          define_class_operation(operation)
          define_instance_operation(operation)
        end
      end

      def instance_operations(*operations)
        operations.each do |operation|
          define_instance_operation(operation)
        end
      end

      def class_operations(*operations)
        operations.each do |operation|
          define_class_operation(operation)
        end
      end

      def request operation, message, locals={}, &block
        message = convert_message_keys message
        locals[:message] = message
        operation_name = full_operation_name(operation)
        resp = client.call operation_name.to_sym, locals
        block.call resp if block_given?
        resp.body[(operation_name+'_response').to_sym][(operation_name+'_result').to_sym]
      end

      protected

      # Defines a class-level SOAP operation.
      def define_class_operation(operation)
        self.class.send(:define_method, operation, lambda{|message={}, locals={}, &block|
          request(operation, message, locals, &block)
        })
        self.class.send(:protected, operation)
      end

      # Defines an instance-level SOAP operation.
      def define_instance_operation(operation)
        define_method(operation) {|message={}, locals={}, &block|
          self.class.request operation, message, locals, &block}
        protected operation
      end


      def full_operation_name short
        return short.to_s if [:connect, :disconnect].include? short.to_sym
        snake_name+'_'+short.to_s
      end

      def snake_name
        self.name.demodulize.underscore
      end

      # this method is bc of E-conomic strange camelcase
      # request keys rules - first lowerCamelCase, others - UpperCamelCase
      def convert_message_keys hash, direction = :lower
        return Hash[hash.map{|key, val| [key.to_s.camelcase(direction).to_sym, convert_message_keys(val, :upper)]}] if hash.is_a? Hash
        return hash.map{|val| convert_message_keys val, :upper} if hash.is_a? Array
        hash
      end

    end
  end
end
