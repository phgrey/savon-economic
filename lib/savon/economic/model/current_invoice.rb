module Savon::Economic::Model
  class CurrentInvoice < Base

    self.id_number= :id
  end


=begin
  Example with minimum fields required to save the entity
  def for_economic
    {
        debtor_handle: {number: client.external_id},
        #number: '',
        debtor_name: client.name,
        date: created_at.strftime('%Y-%m-%dT00:00:00'), #2013-02-05T00:00:00
        term_of_payment_handle: {id: 1},
        due_date:  get_visa_date.strftime('%Y-%m-%dT00:00:00'),
        currency_handle:  {code:  Settings.currency},
        exchange_rate:  100,
        is_vat_included:  true,
        layout_handle:  {id: economic_config[:layout]},
        delivery_address: address.commed_lines,
        delivery_postal_code: address.zipcode,
        delivery_city: address.city,
        delivery_country: address.country.title,
        terms_of_delivery: '',
        delivery_date: get_visa_date.strftime('%Y-%m-%dT00:00:00'),
        #TODO: fixit
        heading: number||'make me number',
        other_reference: "Manager: #{contact_person.name}\nTraveler(s): #{travellers.map{|t|t.name}.join(', ')}\nInvoice ref: #{reference}",
        #is_archived:  false,
        #is_sent:  false,
        net_amount:  0,
        vat_amount:  0,
        gross_amount:  0,
        margin:  0,
        margin_as_percent:  0,
    }
  end
=end

end