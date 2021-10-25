class AddMetaAboutUsToSpreeVendors < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_vendors, :meta_about_us, :string
  end
end
