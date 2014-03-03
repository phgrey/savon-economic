require 'savon/soap_fault'

# As far i do not want to inherit from Savon::Exception own
# i'll extend it with several methods to check

module Savon::Economic::Exception
  def is_integrity?
    check_with_regexp /Economic\.Api\.Exceptions\.IntegrityException/
  end

#(soap:Client) Economic.Api.Exceptions.AuthenticationException(E02250): Not logged in - could not resolve authenticationContext (id=04c58cfc-9b1f-40af-ba48-b74864a3fad4)

  def is_auth_not_logged?
    check_with_regexp(/Economic\.Api\.Exceptions\.AuthenticationException.*User is not authenticated/) ||
      check_with_regexp(/Economic\.Api\.Exceptions\.AuthenticationException.*Not logged in/)
  end

  def is_module_stock_not_installed?
    check_with_regexp /Economic\.Api\.Exceptions\.AuthorizationException.*To use this feature you must be authorized to use the Stock add-on module/

  end

  private

  def check_with_regexp reg
    !(reg=~message).nil?
  end
end