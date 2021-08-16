require 'rack/multipart'
require 'geocoding_service'
require 'csv'
require 'concurrent'

class MerchantsController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_user!

  def create
    env = {
      'CONTENT_TYPE' => request.headers['Content-Type'],
      'CONTENT_LENGTH' => request.body.length,
      'rack.input' => StringIO.new(request.body.read)
    }

    data = Rack::Multipart.parse_multipart(env)
    csv_data = CSV.parse read_parsed_multipart data
    csv_data.shift # remove headers line
    valid_data = Concurrent::Array.new
    invalid_data = Concurrent::Array.new
    start = Time.now
    threads = []
    csv_data.each do |entry|
      begin
      # threads << Thread.new {
        city_name = entry[1].to_s
        merchant_name = entry[0].to_s
        country_code = entry[3].to_s
        street_name = entry[2].to_s.strip
        street_name.force_encoding("UTF-8")

        logger.debug "\tMerchant: #{entry[0]}\tCity name:#{city_name}\tCountry Code:#{country_code}"

        # It's mandatory for city, country_code and merchant fields to have values
        unless (city_name.nil? or city_name.empty?) and 
               (country_code.nil? or country_code.empty?) and
               (merchant_name.nil? or merchant_name.empty?)

          city_name = clean(city_name)
          merchant_name = clean(merchant_name)
          country_code = clean(country_code)

          # Verify if merchant's city corresponds to indicated country
          # There are 2 ways to validate this:
          #    - prepopulation of db in seeds.rb with countries and cities
          #    - use of an external API
          city = City.find_or_initialize_by(name: city_name)
          country = Country.find_or_initialize_by(code: country_code)

          if not country.includes?(city)
            # City is valid
            logger.debug " --- FOUND IN DB"

            merchant = Merchant.find_or_create_by(name: merchant_name)

            country_city = country.country_cities.find_by(country: country, city: city)
            address = Address.find_by(street: street_name, country_city_id: country_city.id)
            address ||= Address.new(street: street_name, country_city_id: country_city.id) 

            merchant_address = MerchantAddress.new(merchant:merchant, address: address)

            city.save
            address.save
            merchant_address.save

            valid_data.push({m: entry[0].to_s, c: city, cc: country_code})
          else
            logger.debug " --- CHECKING REMOTELY"
            if GeocodingService.valid_city?(city_name, country_code)
              country_city = CountryCity.new(country: country, city: city)
              merchant = Merchant.find_or_create_by(name: merchant_name)

              address = Address.find_by(street: street_name, country_city: country_city)
              address ||= Address.new(street: street_name, country_city: country_city)

              merchant_address = MerchantAddress.new(merchant:merchant, address: address)

              city.save
              country.save
              country_city.save
              address.save
              merchant_address.save

              valid_data.push({m: entry[0].to_s, c: city, cc: country_code})
            else
              invalid_data.push({m: entry[0].to_s, c: city, cc: country_code})
            end
          end
        else
          invalid_data.push({m: entry[0].to_s, c: city, cc: country_code})
        end
      # rescue => e
      #   logger.error "Error type: #{e.class}.\nMessage: #{e.message}"
      #   invalid_data.push({m: entry[0].to_s, c: city, cc: country_code})
      #   next
      end
      # }
    end

    # threads.each(&:join)
    stop = Time.now
    puts "Done in: " + (stop - start).to_s

    render json: { vnr: valid_data.length, invnr: invalid_data.length, v: valid_data.to_s, inv: invalid_data.to_s }
  end


  def index
    @search = params[:filter]
    if not (@search.nil? or @search.empty?)
      @merchant_addresses = MerchantAddress.search(params[:filter])
    else
      @merchant_addresses = MerchantAddress.all
    end
  end

  private
    def clean(str)
      s = str.to_s.strip.downcase
      s.force_encoding("UTF-8")
      s = s.gsub(/[^0-9A-Za-z\s]/, '') 
      logger.debug "Cleaning  before: '#{str}'"
      logger.debug "          after : '#{s}'"
      s
    end

    def read_parsed_multipart(data)
      data['file'][:tempfile].read
    end
end
