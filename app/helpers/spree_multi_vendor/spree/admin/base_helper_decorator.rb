module SpreeMultiVendor::Spree::Admin::BaseHelperDecorator
  def vendor_preview_link(vendor)
    button_link_to(
    	Spree.t(:preview_vendor),
	    spree_storefront_resource_url(vendor)+"/#{vendor.slug}",
	    class: 'btn-outline-secondary', icon: 'view.svg', id: 'admin_preview_vendor', target: :blank
	    )
  end

end

Spree::Admin::BaseHelper.prepend SpreeMultiVendor::Spree::Admin::BaseHelperDecorator