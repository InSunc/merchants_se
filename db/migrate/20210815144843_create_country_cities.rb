class CreateCountryCities < ActiveRecord::Migration[5.2]
  def change
    create_table :country_cities do |t|
      t.references :country, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end
  end
end
