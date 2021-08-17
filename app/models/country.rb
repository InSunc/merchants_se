class Country < ApplicationRecord
    has_many :country_cities
    has_many :cities, through: :country_cities

    def includes?(city)
        self.country_cities.find_by(city: city).nil?
    end
end
