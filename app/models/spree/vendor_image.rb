module Spree
  class VendorImage < Asset
    include Spree::Image::Configuration::ActiveStorage
    include Rails.application.routes.url_helpers
    include ::Spree::ImageMethods
    
    def styles
      self.class.styles.map do |_, size|
        width, height = size[/(\d+)x(\d+)/].split('x')

        {
          url: generate_url(size: size),
          size: size,
          width: width,
          height: height
        }
      end
    end


  end
end
