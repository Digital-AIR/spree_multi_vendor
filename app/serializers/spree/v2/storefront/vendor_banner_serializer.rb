module Spree
  module V2
    module Storefront
      class VendorBannerSerializer < BaseSerializer
      	include ::Spree::Api::V2::ImageTransformationConcern
        set_type :vendor_banner

        attributes :styles, :alt, :original_url
      end
    end
  end
end
