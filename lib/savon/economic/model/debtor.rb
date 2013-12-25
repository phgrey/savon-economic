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

    class_operations :get_delivery_locations, :get_debtor_contacts
    def self.delivery_locations id
      ids = get_delivery_locations(self_handle => {id_number => id})
      ids && Savon::Economic::Model::DeliveryLocation.by_handles(ids) || []
    end

    def delivery_locations
      self.class.delivery_locations external_id
    end

    def self.contacts id
      ids = get_debtor_contacts(self_handle => {id_number => id})
      ret = ids && Savon::Economic::Model::DebtorContact.by_handles(ids) || []
      ret.is_a?(Array) ? ret : [ret]
    end

    def contacts
      self.class.contacts external_id
    end


    class_operations :get_price_group
    def self.get_price_group id
      super(self_handle => {id_number => id})
    end

    def price_group
      self.class.get_price_group external_id
    end
  end
end