module Savon::Economic::Model
  class DebtorGroup < Base
    class_operations :get_debtors

    def self.get_debtors id
      super(id_to_handle id)[:debtor_handle].map{|az|az[:number]}
    end
  end
end