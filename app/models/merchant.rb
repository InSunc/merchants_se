class Merchant < ApplicationRecord
    has_many: :merchant_address
    has_many: :address, through: :merchant_address
end
