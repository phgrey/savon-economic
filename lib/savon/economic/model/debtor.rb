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
      ids && DeliveryLocation.by_handles(ids) || []
    end

    def delivery_locations
      self.class.delivery_locations external_id
    end

    def self.contacts id
      ids = get_debtor_contacts(self_handle => {id_number => id})
      ret = ids && DebtorContact.by_handles(ids) || []
      ret.is_a?(Array) ? ret : [ret]
    end

    def contacts
      self.class.contacts external_id
    end


    class_operations :get_price_group
    def self.get_price_group id
      pg = super id_to_handle id
      pg && pg[:number]
    rescue Savon::SOAPFault => ex
      raise ex unless ex.is_module_stock_not_installed?
      0
    end

    def price_group
      self.class.get_price_group external_id
    end

    def self.by_group number
      DebtorGroup.get_debtors number
    end


    class_operations :get_term_of_payment
    def self.get_term_of_payment id
      super id_to_handle id
    end

    def term_of_payment
      self.class.get_term_of_payment(external_id)[:id]
    end


    class_operations :find_by_email, :find_by_name
    def self.by_email email
      hnd = find_by_email(email:email)[:debtor_handle]
      hnd && hnd[:debtor_handle]
    end

    def self.by_name name
      hnd = find_by_name(name:name)
      hnd && hnd[:debtor_handle]
    end

  end
end