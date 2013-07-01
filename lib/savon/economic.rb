require 'savon/economic/version'
require 'active_record/base'
require 'savon/soap_fault'

ActiveRecord::Base.send(:extend, Savon::Economic::ActiveRecord)

module Savon
  module Economic
    extend Helper
  end
  SOAPFault.send :include, Economic::Exception
end