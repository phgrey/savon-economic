# Make components auto-loadable
require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)

require 'savon/economic'

module Savon
  module Economic

  end
end


require 'savon/economic/wasabi_patch'