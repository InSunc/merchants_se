class CreateMerchantAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :merchant_addresses do |t|
      t.references :merchant, foreign_key: true
      t.references :address, foreign_key: true
      t.jsonb :extra

      t.timestamps
    end
  end
end
