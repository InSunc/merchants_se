class CreateMerchantAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :merchant_addresses do |t|
      t.references :merchant, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.jsonb :extra

      t.timestamps
    end
  end
end
