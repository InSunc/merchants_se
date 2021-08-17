class City < ApplicationRecord
    has_many :country_cities
    has_many :countries, through: :country_cities
end
