module SpreeMultiVendor::Spree::Stock::PackageDecorator
  def shipping_methods
    vendor = Spree::StockLocation.method_defined?(:vendor) ? stock_location.vendor : nil

    # return only shipping methods for this Vendor
    if vendor
      Spree::ShippingMethod.all
    else
      shipping_categories.map(&:shipping_methods).reduce(:&).to_a
    end
  end
end

Spree::Stock::Package.prepend SpreeMultiVendor::Spree::Stock::PackageDecorator
