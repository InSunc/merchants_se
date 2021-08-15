class City < ApplicationRecord
    has_many :country_city
    has_many :country, through: :country_city
end
