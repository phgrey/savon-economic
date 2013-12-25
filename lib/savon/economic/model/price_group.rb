module Savon::Economic::Model
  class PriceGroup < Base

    class_operations :get_price, :get_products
    def self.get_price price_group, product
      super({price_group_handle:{number:price_group}, product_handle:{number:product}})
    end

    def self.get_products group_id
      ids = super(self_handle => {id_number => group_id})
      ids[:product_handle]
    rescue Savon::SOAPFault => ex
      raise ex unless ex.is_integrity?
      []
    end

  end
end