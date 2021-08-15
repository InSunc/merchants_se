class Address < ApplicationRecord
  has_many: :merchant_address
  has_many: :merchant, through: :merchant_address
  belongs_to :country_city
end
