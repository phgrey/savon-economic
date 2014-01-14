module Savon::Economic::Model
  class ProductGroup < Base


    class_operations :get_products
    def self.get_products group_id
      ids = super(self_handle => {id_number => group_id})
      ids && ids[:product_handle] || []
    end

  end
end