require_relative 'utils.rb'

# frozen_string_literal: true

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
      # @return [String]
      attr_accessor :key

      # The Streaming API is an HTTP-based service that returns
      # a real-time stream of data collected by Shodan.
      URL = 'https://stream.shodan.io/'

      # @param key [String] SHODAN API key, defaulted to the *SHODAN_API_KEY* enviroment variable.
      def initialize(key: ENV['SHODAN_API_KEY'])
        @url      = URL
        @internet = Async::HTTP::Internet.new
        self.key  = key

        warn 'No key has been found or provided!' unless key?
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
        slurp_stream('shodan/banners', params) do |data|
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
        slurp_stream("shodan/asn/#{asns.join(',')}", params) do |data|
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
        slurp_stream("shodan/countries/#{params.join(',')}") do |data|
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
        slurp_stream("shodan/ports/#{params.join(',')}") do |data|
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
        slurp_stream('alert') do |data|
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
        if Async::Task.current?
          async_slurp_stream(path, params) do |result|
            yield result
          end
        else
          sync_slurp_stream(path, params) do |result|
            yield result
          end
        end
      end

      def slurper(path, **params)
        # param keys should all be strings
        params = params.transform_keys(&:to_s)
        # check if limit
        if (limit = params.delete('limit'))
          counter = 0
        end
        # make GET request to server
        resp = @internet.get("#{@url}#{path}?key=#{@key}", params)
        # read body line-by-line
        until resp.body.nil? || resp.body.empty?
          resp.body.read.each_line do |line|
            next if line.strip.empty?

            yield JSON.parse(line)
            if limit
              counter += 1
              resp.close if counter == limit
            end
          end
        end
      ensure
        resp&.close
      end

      def async_slurp_stream(path, **params)
        Async::Task.current.async do
          slurper(path, params) { |data| yield data }
        end
      end

      def sync_slurp_stream(path, **params)
        Async do
          slurper(path, params) { |data| yield data }
        end.wait
      end
    end
  end
end
