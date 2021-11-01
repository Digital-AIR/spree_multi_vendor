module SpreeMultiVendor::Spree::Admin::CustomerReturnsControllerDecorator
	def self.prepended(base)
       base.before_action :load_stock_locations
    end 

	def load_form_data
	  return_items = @order.return_items.accessible_by(current_ability)
      @rma_return_items = return_items.select(&:return_authorization_id)
    end

    def load_stock_locations
      @all_stock_locations =  Spree::StockLocation.accessible_by(current_ability) 
      @stock_locations = @all_stock_locations.order_default.active.to_a.collect{|l|[l.name.humanize, l.id]}
    end 
end
Spree::Admin::CustomerReturnsController.prepend SpreeMultiVendor::Spree::Admin::CustomerReturnsControllerDecorator