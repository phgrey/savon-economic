module Savon::Economic::Model
  class Product < Base

    class_operations :find_by_bar_code
    def self.by_code code
      handle = find_by_bar_code bar_code:code
      handle && by_handles([handle])
    end

  end
end