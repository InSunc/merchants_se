class MerchantAddress < ApplicationRecord
  include PgSearch::Model

  belongs_to :merchant
  belongs_to :address
  store_accessor :extra, :phone, :website
  pg_search_scope :search, :against => :extra, associated_against: { merchant: :name }
end
