require_relative 'utils.rb'

# frozen_string_literal: true

module Shodanz
  module API
    # The REST API provides methods to search Shodan, look up
    # hosts, get summary information on queries and a variety
    # of other utilities. This requires you to have an API key
    # which you can get from Shodan.
    #
    # @author Kent 'picat' Gruber
    class REST
      include Shodanz::API::Utils

      # @return [String]
      attr_accessor :key

      # The path to the REST API endpoint.
      URL = 'https://api.shodan.io/'

      # @param key [String] SHODAN API key, defaulted to the *SHODAN_API_KEY* enviroment variable.
      def initialize(key: ENV['SHODAN_API_KEY'])
        @url      = URL
        @client   = Async::HTTP::Client.new(Async::HTTP::Endpoint.parse(@url))
        self.key  = key

        warn 'No key has been found or provided!' unless key?
      end

      # Check if there's an API key.
      def key?
        return true if @key

        false
      end

      # Returns all services that have been found on the given host IP.
      # @param ip [String]
      # @option params [Hash]
      # @return [Hash]
      # == Examples
      #   # Typical usage.
      #   rest_api.host("8.8.8.8")
      #
      #   # All historical banners should be returned.
      #   rest_api.host("8.8.8.8", history: true)
      #
      #   # Only return the list of ports and the general host information, no banners.
      #   rest_api.host("8.8.8.8", minify: true)
      def host(ip, **params)
        get("shodan/host/#{ip}", **params)
      end

      # This method behaves identical to "/shodan/host/search" with the only
      # difference that this method does not return any host results, it only
      # returns the total number of results that matched the query and any
      # facet information that was requested. As a result this method does
      # not consume query credits.
      # == Examples
      #   rest_api.host_count("apache")
      #   rest_api.host_count("apache", country: "US")
      #   rest_api.host_count("apache", country: "US", state: "MI")
      #   rest_api.host_count("apache", country: "US", state: "MI", city: "Detroit")
      def host_count(query = '', facets: {}, **params)
        params[:query] = query
        params = turn_into_query(**params)
        facets = turn_into_facets(**facets)
        get('shodan/host/count', **params.merge(**facets))
      end

      # Search Shodan using the same query syntax as the website and use facets
      # to get summary information for different properties.
      # == Example
      #   rest_api.host_search("apache", country: "US", facets: { city: "Detroit" }, page: 1, minify: false)
      def host_search(query = '', facets: {}, page: 1, minify: true, **params)
        params[:query] = query
        params = turn_into_query(**params)
        facets = turn_into_facets(**facets)
        params[:page] = page
        params[:minify] = minify
        get('shodan/host/search', **params.merge(**facets))
      end

      # This method lets you determine which filters are being used by
      # the query string and what parameters were provided to the filters.
      def host_search_tokens(query = '', **params)
        params[:query] = query
        params = turn_into_query(**params)
        get('shodan/host/search/tokens', **params)
      end

      # This method returns a list of port numbers that the crawlers are looking for.
      def ports
        get('shodan/ports')
      end

      # List all protocols that can be used when performing on-demand Internet scans via Shodan.
      def protocols
        get('shodan/protocols')
      end

      # Use this method to request Shodan to crawl a network.
      #
      # This method uses API scan credits: 1 IP consumes 1 scan credit. You
      # must have a paid API plan (either one-time payment or subscription)
      # in order to use this method.
      #
      # IP, IPs or netblocks (in CIDR notation) that should get crawled.
      def scan(*ips)
        post('shodan/scan', ips: ips.join(','))
      end

      # Use this method to request Shodan to crawl the Internet for a specific port.
      #
      # This method is restricted to security researchers and companies with
      # a Shodan Data license. To apply for access to this method as a researcher,
      # please email jmath@shodan.io with information about your project.
      # Access is restricted to prevent abuse.
      #
      # == Example
      #   rest_api.crawl_for(port: 80, protocol: "http")
      def crawl_for(**params)
        params[:query] = ''
        params = turn_into_query(**params)
        post('shodan/scan/internet', **params)
      end

      # Check the progress of a previously submitted scan request.
      def scan_status(id)
        get("shodan/scan/#{id}")
      end

      # Use this method to obtain a list of search queries that users have saved in Shodan.
      def community_queries(**params)
        get('shodan/query', **params)
      end

      # Use this method to search the directory of search queries that users have saved in Shodan.
      def search_for_community_query(query, **params)
        params[:query] = query
        params = turn_into_query(**params)
        get('shodan/query/search', **params)
      end

      # Use this method to obtain a list of popular tags for the saved search queries in Shodan.
      def popular_query_tags(size = 10)
        params = {}
        params[:size] = size
        get('shodan/query/tags', **params)
      end

      # Returns information about the Shodan account linked to this API key.
      def profile
        get('account/profile')
      end

      # Look up the IP address for the provided list of hostnames.
      def resolve(*hostnames)
        get('dns/resolve', hostnames: hostnames.join(','))
      end

      # Look up the hostnames that have been defined for the
      # given list of IP addresses.
      def reverse_lookup(*ips)
        get('dns/reverse', ips: ips.join(','))
      end

      # Shows the HTTP headers that your client sends when
      # connecting to a webserver.
      def http_headers
        get('tools/httpheaders')
      end

      # Get your current IP address as seen from the Internet.
      def my_ip
        get('tools/myip')
      end

      # Calculates a honeypot probability score ranging
      # from 0 (not a honeypot) to 1.0 (is a honeypot).
      def honeypot_score(ip)
        get("labs/honeyscore/#{ip}")
      end

      # Returns information about the API plan belonging to the given API key.
      def info
        get('api-info')
      end
    end
  end
end
