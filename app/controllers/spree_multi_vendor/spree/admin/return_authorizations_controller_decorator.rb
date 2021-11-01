module SpreeMultiVendor::Spree::Admin::ReturnAuthorizationsControllerDecorator
	def self.prepended(base)
      base.before_action :parent
      base.before_action :load_stock_locations
    end 

	def load_return_items
        all_inventory_units = @return_authorization.order.inventory_units.accessible_by(current_ability)
        retured_items = @return_authorization.return_items.accessible_by(current_ability)
        associated_inventory_units = retured_items.map(&:inventory_unit)
        unassociated_inventory_units = all_inventory_units - associated_inventory_units

        new_return_items = unassociated_inventory_units.map do |new_unit|
          Spree::ReturnItem.new(inventory_unit: new_unit, return_authorization: @return_authorization).tap(&:set_default_pre_tax_amount)
        end

        @form_return_items = (retured_items + new_return_items).sort_by(&:inventory_unit_id)
    end

    def load_stock_locations
    	@all_stock_locations =  Spree::StockLocation.accessible_by(current_ability) 
    	@stock_locations = @all_stock_locations.order_default.active.to_a.collect{|l|[l.name.humanize, l.id]}
    end 

    def collection
        parent # trigger loading the order

        order_return_authorization_ids = @order.return_items.accessible_by(current_ability).pluck(:return_authorization_id).uniq.compact
        @collection ||= current_store.return_authorizations.where(id: order_return_authorization_ids)
        @return_authorizations = @collection
     end
end
Spree::Admin::ReturnAuthorizationsController.prepend SpreeMultiVendor::Spree::Admin::ReturnAuthorizationsControllerDecorator