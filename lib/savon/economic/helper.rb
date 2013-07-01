module Savon::Economic
  module Helper
    def config
      Model::Base.config
    end

    def to_install
      fake_acc = {:number=>"1100"}
      {
          layout: [Model::TemplateCollection, config[:layout], nil],
          group: [Model::DebtorGroup,
                  config[:debtor_groups].values.uniq,
                  {name: 'Auto-generated debtor group', :account_handle=>fake_acc}
          ],
          product_group: [Model::ProductGroup,
                          (config[:department] == 1 ? [1,2,3,10] : [101, 102, 103, 110]),
                          {name: 'Auto-generated product group',
                           account_for_vat_liable_debtor_invoices_current_handle: fake_acc,
                           account_for_vat_exempt_debtor_invoices_current_handle: fake_acc
                          }
          ],
          department: [Model::Department, config[:department], {name:'Auto-generated department'}]
      }
    end

    # Takes a hash of components
    def installed? components = nil
      Hash[(components || to_install).map{|k, args|[k, cmp_installed?(*args)]}]
    end


    def install! components = nil
      (components || to_install.values).map{|args|cmp_install! *args}
      Product.all.each{|p|p.remote.create! true}
    end

  private

    def cmp_installed? class_value, ids, default_values={}
      class_value.find(ids) && true
    rescue Savon::SOAPFault => ex
      raise ex unless ex.is_integrity?
      false
    end

    def cmp_install! class_value, ids=[], default_values={}
      ids = [ids] unless ids.is_a? Array
      ids.each do |id|
        begin
          class_value.find id
        rescue Savon::SOAPFault => ex
          raise ex if !ex.is_integrity? || default_values.nil?
          class_value.create(class_value.id_handle(id).merge default_values)
        end
      end
    end

  end
end