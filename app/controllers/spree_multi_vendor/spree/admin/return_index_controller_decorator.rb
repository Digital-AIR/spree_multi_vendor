module SpreeMultiVendor::Spree::Admin::ReturnIndexControllerDecorator

  def return_authorizations
  	resource = Spree::ReturnAuthorization.accessible_by(current_ability)
    collection(resource)
    respond_with(@collection)
  end

  def customer_returns
  	resource = Spree::CustomerReturn.accessible_by(current_ability)
    collection(resource)
    respond_with(@collection)
  end

  
  def collection(resource)
    return @collection if @collection.present?
    params[:q] ||= {} if params[:q].blank?
    @search = resource.ransack(params[:q])
    @collection = @search.result.order(created_at: :desc).page(params[:page]).per(params[:per_page])
  end	
  		
end

Spree::Admin::ReturnIndexController.prepend SpreeMultiVendor::Spree::Admin::ReturnIndexControllerDecorator