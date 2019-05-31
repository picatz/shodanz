# frozen_string_literal: true

require_relative 'representation'

module Shodanz
  module API
    # The REST API provides methods to search Shodan, look up
    # hosts, get summary information on queries and a variety
    # of other utilities. This requires you to have an API key
    # which you can get from Shodan.
    #
    # @author Kent 'picat' Gruber
    class REST < Representation
      include Shodanz::API::Utils

      # The path to the REST API endpoint.
      DEFAULT_URL = 'https://api.shodan.io/'

      # @param key [String] SHODAN API key, defaulted to the *SHODAN_API_KEY* enviroment variable.
      def initialize(resource = nil, key: ENV['SHODAN_API_KEY'], metadata: {}, value: nil, wrapper: Wrapper::JSON.new)
        # This is a little bit of a hack to support `REST.new` with no arguments.
        if resource.nil?
          reference = ::Protocol::HTTP::Reference.parse(DEFAULT_URL, key: key)
          resource = Async::REST::Resource.for(reference)
        end

        super(resource, metadata: metadata, value: value, wrapper: wrapper)
      end

      def turn_into_query(params)
        filters = params.reject { |key, _| key == :query }
        filters.each do |key, value|
          params[:query] << " #{key}:#{value}"
        end
        params.select { |key, _| key == :query }
      end

      def hosts(ips, **parameters)
        async do
          ips.each do |ip|
            Async do
              h = host(ip, parameters)
              yield h if block_given?
              hosts << h
            end
          end
        end
        hosts
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
      def host(ip, **parameters)
        get_value("/shodan/host/#{ip}", parameters)
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
        params = turn_into_query(params)
        facets = turn_into_facets(facets)
        get_value('shodan/host/count', params.merge(facets))
      end

      # Search Shodan using the same query syntax as the website and use facets
      # to get summary information for different properties.
      # == Example
      #   rest_api.host_search("apache", country: "US", facets: { city: "Detroit" }, page: 1, minify: false)
      def host_search(query = '', facets: {}, page: 1, minify: true, **params)
        params[:query] = query
        params = turn_into_query(params)
        facets = turn_into_facets(facets)
        params[:page] = page
        params[:minify] = minify
        get_value('shodan/host/search', params.merge(facets))
      end

      # This method lets you determine which filters are being used by
      # the query string and what parameters were provided to the filters.
      def host_search_tokens(query = '', **params)
        params[:query] = query
        params = turn_into_query(params)
        get_value('shodan/host/search/tokens', params)
      end

      # This method returns a list of port numbers that the crawlers are looking for.
      def ports
        get_value('shodan/ports')
      end

      # List all protocols that can be used when performing on-demand Internet scans via Shodan.
      def protocols
        get_value('shodan/protocols')
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
        params = turn_into_query(params)
        post('shodan/scan/internet', params)
      end

      # Check the progress of a previously submitted scan request.
      def scan_status(id)
        get_value("shodan/scan/#{id}")
      end

      # Use this method to obtain a list of search queries that users have saved in Shodan.
      def community_queries(**params)
        get_value('shodan/query', params)
      end

      # Use this method to search the directory of search queries that users have saved in Shodan.
      def search_for_community_query(query, **params)
        params[:query] = query
        params = turn_into_query(params)
        get_value('shodan/query/search', params)
      end

      # Use this method to obtain a list of popular tags for the saved search queries in Shodan.
      def popular_query_tags(size = 10)
        params = {}
        params[:size] = size
        get_value('shodan/query/tags', params)
      end

      # Returns information about the Shodan account linked to this API key.
      def profile
        get_value('account/profile')
      end

      # Look up the IP address for the provided list of hostnames.
      def resolve(*hostnames)
        get_value('dns/resolve', hostnames: hostnames.join(','))
      end

      # Look up the hostnames that have been defined for the
      # given list of IP addresses.
      def reverse_lookup(*ips)
        get_value('dns/reverse', ips: ips.join(','))
      end

      # Shows the HTTP headers that your client sends when
      # connecting to a webserver.
      def http_headers
        get_value('tools/httpheaders')
      end

      # Get your current IP address as seen from the Internet.
      def my_ip
        get_value('tools/myip')
      end

      # Calculates a honeypot probability score ranging
      # from 0 (not a honeypot) to 1.0 (is a honeypot).
      def honeypot_score(ip)
        get_value("labs/honeyscore/#{ip}")
      end

      # Returns information about the API plan belonging to the given API key.
      def info
        get_value('api-info')
      end
    end
  end
end
