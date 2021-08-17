class Merchant < ApplicationRecord
    has_many :merchant_addresses
    has_many :addresses, through: :merchant_addresses
end
