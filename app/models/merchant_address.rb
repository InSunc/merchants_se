class MerchantAddress < ApplicationRecord
  belongs_to :merchant
  belongs_to :address
end
