module Spree
  module V2
    module Storefront
      class VendorImageSerializer < BaseSerializer
      	include ::Spree::Api::V2::ImageTransformationConcern
        set_type :vendor_image

        attributes :styles, :alt, :original_url
      end
    end
  end
end
