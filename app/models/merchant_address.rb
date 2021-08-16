class MerchantAddress < ApplicationRecord
  include PgSearch::Model

  belongs_to :merchant
  belongs_to :address

  pg_search_scope :search, associated_against: { merchant: :name }

end
