module Savon::Economic::Model
  class Debtor < Base

    class_operations :get_debtor_contacts
    def self.get_contact_ids debtor_id
      ids = get_debtor_contacts(debtor_handle:{id_number => debtor_id})
      ids.nil?? [] : ids[:debtor_contact_handle].is_a?(Array) ? ids[:debtor_contact_handle].map{|h|h[:id]} : [ids[:debtor_contact_handle][:id]]
    end

    def get_contact_ids
      self.class.get_contact_ids external_id
    end
  end
end