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
      # threads << Thread.new {
        city = entry[1].to_s
        merchant = entry[0].to_s
        country_code = entry[3].to_s

        logger.debug "\tMerchant: #{entry[0]}\tCity:#{city}\tCountry Code:#{country_code}"

        # It's mandatory city, country_code and merchant fields to have values
        unless (city.nil? or city.empty?) and 
               (country_code.nil? or country_code.empty?) and
               (merchant.nil? or merchant.empty?)

          city = clean(city)
          merchant = clean(merchant)
          country_code = clean(country_code)

          # Verify if merchant's city corresponds to indicated country
          # There are 2 ways to validate this:
          #    - prepopulation of db in seeds.rb with countries and cities
          #    - use of an external API
          if GeocodingService.valid_city?(city, country_code)
            valid_data.push({m: entry[0].to_s, c: city, cc: country_code})
          else
            invalid_data.push({m: entry[0].to_s, c: city, cc: country_code})
          end

        else
          invalid_data.push({m: entry[0].to_s, c: city, cc: country_code})
        end
      # }
    end

    # threads.each(&:join)
    stop = Time.now
    puts "Done in: " + (stop - start).to_s

    render json: { vnr: valid_data.length, invnr: invalid_data.length, v: valid_data.to_s, inv: invalid_data.to_s }
  end


  def index
    result = GeocodingService.valid_city?(params["c"], params["cc"])

    render json: result
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
