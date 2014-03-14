module Savon::Economic::Model
  class Invoice < Base

    class_operations :find_by_order_number
    def self.by_order order_id
      hnd = find_by_order_number order_number:order_id
      hnd && get_data(entity_handle:hnd[:invoice_handle])
    end
  end
end