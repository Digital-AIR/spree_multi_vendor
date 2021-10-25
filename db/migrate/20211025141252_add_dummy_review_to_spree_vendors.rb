class AddDummyReviewToSpreeVendors < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_vendors, :dummy_review, :text
  end
end
