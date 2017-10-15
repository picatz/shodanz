module Shodanz

  module API
    # The REST API provides methods to search Shodan, look up 
    # hosts, get summary information on queries and a variety 
    # of other utilities. This requires you to have an API key
    # which you can get from Shodan.
    #
    # Note: Only 1-5% of the data is currently provided to 
    # subscription-based API plans. If your company is interested 
    # in large-scale, real-time access to all of the Shodan data 
    # please contact us for pricing information (sales@shodan.io).
    # 
    # @author Kent 'picat' Gruber
    class Streaming
      # The Streaming API is an HTTP-based service that returns 
      # a real-time stream of data collected by Shodan.
      URL = "https://stream.shodan.io/"

      # @param key [String] SHODAN API key, defaulted to the *SHODAN_API_KEY* enviroment variable.
      def initialize(key: ENV['SHODAN_API_KEY'])
        self.key = key
        warn "No key has been found or provided!" unless self.key?
      end

      # Change the API key to a given string.
      # @param key [String]
      def key=(key)
        @key = key
      end

      # Check if there's an API key.
      def key?
        return true if @key; false
      end

      # This stream provides ALL of the data that Shodan collects. 
      # Use this stream if you need access to everything and/ or want to 
      # store your own Shodan database locally. If you only care about specific 
      # ports, please use the Ports stream.
      #
      # Sometimes data may be piped down stream that is weird to parse. You can choose
      # to keep this data optionally; and it will not be parsed for you.
      #
      # == Example
      #   api.banners do |banner|
      #     # do something with banner as hash
      #     puts data
      #   end
      def banners(**params)
        slurp_stream("shodan/banners", params) do |data|
          yield data
        end
      end

      # This stream provides a filtered, bandwidth-saving view of the Banners 
      # stream in case you are only interested in devices located in certain ASNs.
      # == Example
      #   api.banners_within_asns(3303, 32475) do |data| 
      #     # do something with the banner hash
      #     puts data
      #   end
      def banners_within_asns(*asns, **params)
        slurp_stream("shodan/asn/#{asns.join(",")}", params) do |data|
          yield data
        end
      end

      # This stream provides a filtered, bandwidth-saving view of the Banners 
      # stream in case you are only interested in devices located in a certain ASN.
      # == Example
      #   api.banners_within_asn(3303) do |data| 
      #     # do something with the banner hash
      #     puts data
      #   end
      def banners_within_asn(param)
        banners_within_asns(param) do |data|
          yield data
        end
      end

      # Only returns banner data for the list of specified ports. This 
      # stream provides a filtered, bandwidth-saving view of the Banners 
      # stream in case you are only interested in a specific list of ports.
      # == Example
      #   api.banners_within_countries("US","DE","JP") do |data| 
      #     # do something with the banner hash
      #     puts data
      #   end
      def banners_within_countries(*params)
        slurp_stream("shodan/countries/#{params.join(",")}") do |data|
          yield data
        end
      end

      # Only returns banner data for the list of specified ports. This 
      # stream provides a filtered, bandwidth-saving view of the 
      # Banners stream in case you are only interested in a 
      # specific list of ports.
      # == Example
      #   api.banners_on_port(80, 443) do |data| 
      #     # do something with the banner hash
      #     puts data
      #   end
      def banners_on_ports(*params)
        slurp_stream("shodan/ports/#{params.join(",")}") do |data|
          yield data
        end
      end

      # Only returns banner data for a specific port. This 
      # stream provides a filtered, bandwidth-saving view of the 
      # Banners stream in case you are only interested in a 
      # specific list of ports.
      # == Example
      #   api.banners_on_port(80) do |banner|
      #     # do something with the banner hash
      #     puts data
      #   end
      def banners_on_port(param)
        banners_on_ports(param) do |data|
          yield data
        end
      end

      # Subscribe to banners discovered on all IP ranges described in the network alerts.
      # Use the REST API methods to create/ delete/ manage your network alerts and 
      # use the Streaming API to subscribe to them.
      def alerts
        slurp_stream("alert") do |data|
          yield data
        end
      end

      # Subscribe to banners discovered on the IP range defined in a specific network alert.
      def alert(id)
        slurp_stream("alert/#{id}") do |data|
          yield data
        end
      end

      private

      # Perform the main function of consuming the streaming API. 
      def slurp_stream(path, **params)
        uri = URI("#{URL}#{path}?key=#{@key}")
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          request = Net::HTTP::Get.new uri
          begin
            http.request request do |resp|
              raise "Unable to connect to Streaming API" if resp.code != "200"
              # Buffer for Shodan's bullshit.
              raw_body = ""
              resp.read_body do |chunk| 
                if /^\{"product":.*\}\}\n/.match(chunk)
                  begin
                    yield Oj.load(chunk)
                  rescue
                    # yolo
                  end
                elsif /.*\}\}\n$/.match(chunk)
                  next if raw_body.empty?
                  raw_body << chunk
                  raw_body
                elsif /^\{.*\b/.match(chunk) 
                  raw_body << chunk
                end
                if m = /^\{"product":.*\}\}\n/.match(raw_body)
                  index = 0
                  while matched = m[index]
                    index += 1
                    raw_body = raw_body.gsub(/^\{"product":.*\}\}\n/, "")
                    begin
                      yield Oj.load(matched)
                    rescue
                      # yolo
                    end
                  end
                end
              end
            end
          ensure
            http.finish
          end
        end
      end

    end

  end
end
