class AddIndexToMerchantAddress < ActiveRecord::Migration[5.2]
  def change
    add_index :merchant_addresses, :extra, using: :gin
  end
end
