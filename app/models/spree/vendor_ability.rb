class Spree::VendorAbility
  include CanCan::Ability

  def initialize(user)
    @vendor_ids = user.vendors.active.ids

    if @vendor_ids.any?
      apply_classifications_permissions
      apply_order_permissions
      apply_image_permissions
      apply_option_type_permissions
      apply_price_permissions
      apply_product_option_type_permissions
      apply_product_permissions
      apply_product_properties_permissions
      apply_properties_permissions
      apply_prototypes_permissions
      apply_shipment_permissions
      apply_stock_permissions
      apply_stock_item_permissions
      apply_stock_location_permissions
      apply_stock_movement_permissions
      apply_variant_permissions
      apply_vendor_permissions
      apply_vendor_settings_permissions
      apply_state_changes_permissions
      apply_video_permissions
      apply_video_reviews_permissions
      apply_product_reviews_permissions
      apply_related_products_permissions
      apply_return_authorizations_permissions
      apply_customer_returns_permissions
    end
  end

  protected

  def apply_classifications_permissions
    can :manage, Spree::Classification, product: { vendor_id: @vendor_ids }
  end

  def apply_order_permissions
    cannot :create, Spree::Order

    order_scope = if ::Spree::Order.reflect_on_association(:vendor)
                    { vendor_id: @vendor_ids }
                  elsif ::Spree::LineItem.reflect_on_association(:vendor)
                    { line_items: { vendor_id: @vendor_ids } }
                  elsif ::Spree::Product.reflect_on_association(:vendor)
                    { line_items: { product: { vendor_id: @vendor_ids } } }
                  elsif ::Spree::Variant.reflect_on_association(:vendor)
                    { line_items: { variant: { vendor_id: @vendor_ids } } }
                  end

    if order_scope.present?
      can %i[admin show index edit update cart], Spree::Order, order_scope
    else
      cannot_display_model(Spree::Order)
    end
  end

  def apply_image_permissions
    can :create, Spree::Image

    can [:manage, :modify], Spree::Image, ['viewable_type = ?', 'Spree::Variant'] do |image|
      vendor_id = image.viewable.try(:vendor_id)
      vendor_id.present? && @vendor_ids.include?(vendor_id)
    end
  end

  def apply_option_type_permissions
    can :display, Spree::OptionType
    can :display, Spree::OptionValue
  end

  def apply_price_permissions
    can :modify, Spree::Price, variant: { vendor_id: @vendor_ids }
  end

  def apply_product_option_type_permissions
    can :manage,  Spree::ProductOptionType, product: { vendor_id: @vendor_ids }
    can :create,  Spree::ProductOptionType
    can :manage,  Spree::OptionValueVariant, variant: { vendor_id: @vendor_ids }
    can :create,  Spree::OptionValueVariant
  end

  def apply_product_permissions
    cannot_display_model(Spree::Product)

    return unless Spree::Product.reflect_on_association(:vendor)

    can :manage, Spree::Product, vendor_id: @vendor_ids
    can :create, Spree::Product
  end

  def apply_properties_permissions
    can :display, Spree::Property
  end

  def apply_product_properties_permissions
    can :manage,  Spree::ProductProperty, product: { vendor_id: @vendor_ids }
    can :create,  Spree::ProductProperty
  end

  def apply_prototypes_permissions
    can [:read, :admin], Spree::Prototype
  end

  def apply_shipment_permissions
    can :update, Spree::Shipment, inventory_units: { line_item: { product: { vendor_id: @vendor_ids } } }
  end

  def apply_stock_permissions
    can :admin, Spree::Stock
  end

  def apply_stock_item_permissions
    can [:admin, :modify, :read], Spree::StockItem, stock_location: { vendor_id: @vendor_ids }
  end

  def apply_stock_location_permissions
    can :manage, Spree::StockLocation, vendor_id: @vendor_ids
    can :create, Spree::StockLocation
  end

  def apply_stock_movement_permissions
    can :create, Spree::StockMovement
    can :manage, Spree::StockMovement, stock_item: { stock_location: { vendor_id: @vendor_ids } }
  end

  def apply_variant_permissions
    cannot_display_model(Spree::Variant)
    can :manage, Spree::Variant, vendor_id: @vendor_ids
    can :create, Spree::Variant
  end

  def apply_vendor_permissions
    can :manage, Spree::Vendor, id: @vendor_ids
    cannot :create, Spree::Vendor
  end

  def apply_vendor_settings_permissions
    can :manage, :vendor_settings
  end

  def apply_state_changes_permissions
    can [:admin, :index], Spree::StateChange do |state_change|
      (@vendor_ids & state_change.user.vendor_ids).any?
    end
  end

  def apply_video_permissions
    cannot_display_model(Spree::Video)

    return unless Spree::Video.reflect_on_association(:vendor)
    can :modify, Spree::VideoSecondaryProduct
    can :modify, Spree::VideoTaxon
    can :manage, Spree::Video, vendor_id: @vendor_ids
    can :create, Spree::Video
  end

  def apply_video_reviews_permissions
    cannot_display_model(Spree::VideoReview)
    return unless Spree::VideoReview.reflect_on_association(:video)
    can :manage, Spree::VideoReview, video: { vendor_id: @vendor_ids } 
  end

  def apply_product_reviews_permissions
    cannot_display_model(Spree::Review)
    return unless Spree::Review.reflect_on_association(:product)
    can :manage, Spree::Review, product: { vendor_id: @vendor_ids }
  end

  def apply_related_products_permissions
    can :manage, Spree::Relation
  end

  def apply_return_authorizations_permissions

    can :manage, Spree::ReturnAuthorization, stock_location: { vendor_id: @vendor_ids }
    can :manage, Spree::ReturnIndex
    can :create, Spree::ReturnAuthorization

  end

  def apply_customer_returns_permissions
    can :manage, Spree::CustomerReturn, stock_location: { vendor_id: @vendor_ids }
    can :create, Spree::CustomerReturn
    can :manage, Spree::ReturnItem, inventory_unit: {variant: {product:{ vendor_id: @vendor_ids }}}
    can :manage, Spree::InventoryUnit, variant: {product:{ vendor_id: @vendor_ids }}

  end

  def cannot_display_model(model)
    Spree.version.to_f < 4.0 ? (cannot :display, model) : (cannot :read, model)
  end
end
