class Address < ApplicationRecord
  has_many :merchant_addresses
  has_many :merchants, through: :merchant_addresses
  belongs_to :country_city
end
