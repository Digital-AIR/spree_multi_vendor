Deface::Override.new(
  virtual_path: 'spree/admin/customer_returns/new',
  name: 'change_stock_locations_in_customer_returns',
  replace: 'erb[loud]:contains("Spree.t(:select_a_stock_location)")',
  text: <<-HTML
        <%= f.select :stock_location_id, @stock_locations, {include_blank: true}, {class: 'select2-clear', "data-placeholder" => Spree.t(:select_a_stock_location)} %>
        HTML
)
