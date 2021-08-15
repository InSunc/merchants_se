class Country < ApplicationRecord
    has_many :country_city
    has_many :city, through: :country_city
end
