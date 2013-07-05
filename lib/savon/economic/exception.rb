require 'savon/soap_fault'

module Savon::Economic::Exception
  def is_integrity?
    !(/Economic\.Api\.Exceptions\.IntegrityException/=~message).nil?
  end

  def is_auth?
    !(/Economic\.Api\.Exceptions\.AuthenticationException.*User is not authenticated/=~message).nil?
  end
end