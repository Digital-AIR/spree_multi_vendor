module Spree
  module Api
	module V2
	  module Platform
	    class VendorImageSerializer < BaseSerializer
	      include ::Spree::Api::V2::ImageTransformationConcern
	      set_type :vendor_image

	      attributes :styles, :alt, :original_url
	    end
	  end
	end
  end
end
