require 'net/http'

class GeocodingService
    def self.valid_city?(city, country_code)

        # TODO: Problem: It takes a long time to sequatially verify all the cities from csv
        # TODO: Problem: When sending HTTP requests from multiple threads, some requests return as response: "data: [[], [], [], []]"
        #                And it happens sporadically, probably there's a limitation for req/sec. 
        #                Using fproxies might help, if the server checks the req/sec limit by address, ignoring the API key.
        # TODO: Get a working list of proxies.

        # proxy = JSON.parse(Net::HTTP.get(URI("https://proxylist.geonode.com/api/proxy-list?limit=50&page=1&sort_by=speed&sort_type=asc&speed=fast&protocols=http%2Chttps")))['data']
        # index = 1 + rand(proxy.length)
        # proxy_addr = proxy[index]['ip']
        # proxy_port = proxy[index]['port']

        # req = Net::HTTP::Get.new(api_endpoint(city))
        # http = Net::HTTP.new(proxy_addr, proxy_port)
        # http.use_ssl = (proxy[index]['protocols'].first == "https")
        # response = http.request(req)

        response = Net::HTTP.get(api_endpoint(city))
        data = JSON.parse(response)["data"]
        
        if not (data.nil? or data.empty?)
            data.each do |entry|
                e_city = entry['name'].to_s.downcase if not entry['name'].nil?
                e_locality = entry['locality'].to_s.downcase if not entry['locality'].nil?
                e_country_code = entry['country_code'].downcase[0..1] if not entry['country_code'].nil?

                if (city.eql? e_city or city.eql? e_locality) and
                    country_code.eql? e_country_code

                    return true
                end
            end
        end

        false
    end

    private
        API_KEY = "54f4e4a4f7d15d555302fb2c5dda65c6" 
        API_ENDPOINT = "http://api.positionstack.com/v1/forward?access_key=#{API_KEY}&output=json&query="

        def self.api_endpoint(city)
            URI(API_ENDPOINT + city.to_s)
        end
end
 