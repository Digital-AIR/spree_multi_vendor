module SpreeMultiVendor::Spree::Admin::OrdersControllerDecorator
  def order_params
    params[:created_by_id] = try_spree_current_user.try(:id)
    params.require(:cart).permit(:created_by_id, :user_id, :store_id, :channel)
  end

end

Spree::Admin::OrdersController.prepend SpreeMultiVendor::Spree::Admin::OrdersControllerDecorator
