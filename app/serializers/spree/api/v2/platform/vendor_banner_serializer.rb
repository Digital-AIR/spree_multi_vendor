module Spree
  module Api
	module V2
	  module Platform
	     class VendorBannerSerializer < BaseSerializer
	      include ::Spree::Api::V2::ImageTransformationConcern
	      set_type :vendor_banner

	      attributes :styles, :alt, :original_url
	    end
	  end
	end
  end
end
