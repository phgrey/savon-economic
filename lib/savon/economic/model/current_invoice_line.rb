module Savon::Economic::Model
  class CurrentInvoiceLine < Base


  end

=begin
  Example with minimum fields required to save the entity
  def for_economic
    {
        number: 1, #it's ok, E-conomic will replace it by itself
        invoice_handle: {id: order.external_id},
        description: product.title,
        delivery_date: order.get_visa_date.strftime('%Y-%m-%dT00:00:00'),
        product_handle: {number: product.external_id},
        quantity: count,
        unit_net_price: product.price,
        discount_as_percent: 0,
        unit_cost_price: 0,
        total_net_amount: count*product.price,
        total_margin: 0,
        margin_as_percent: 0,
        department_handle: {number: economic_config[:department]}
    }
  end
=end
end