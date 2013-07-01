require 'savon/soap_fault'

module Savon::Economic::Exception
  def is_integrity?
    !(/Economic\.Api\.Exceptions\.IntegrityException/=~message).nil?
  end
end