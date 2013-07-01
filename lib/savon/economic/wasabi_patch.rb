require 'wasabi/parser'

# Here we will make some patches on a Wasabi::Parser
# to be able to save/load parsed data instead of parsing file
# bc e-conomic file is too large and parses few minutes

Wasabi::Parser.class_eval do
  def parse
    return if load_parser
    parse_namespaces
    parse_endpoint
    parse_service_name
    parse_operations
    parse_types
    parse_deferred_types
    save_parser
  end

  #TODO: find less hard way to count md5 of the file
  def cache_file
    hash = Digest::MD5.hexdigest document.canonicalize
    Rails.root.join("tmp/cache/wsdl-#{hash}.tmp")
  end

  def load_parser
    File.open(cache_file) do|file|
      @namespace, @namespaces, @operations, @types, @deferred_types, @endpoint, @service_name, @element_form_default = Marshal.load(file)
    end
    true
  rescue
    false
  end

  def save_parser
    File.open(cache_file,'w') do|file|
      Marshal.dump([@namespace, @namespaces, @operations, @types, @deferred_types, @endpoint, @service_name, @element_form_default], file)
    end
  end
end