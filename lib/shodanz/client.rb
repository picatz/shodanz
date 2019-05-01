# frozen_string_literal: true

module Shodanz
  # General client container class for all three
  # of the available API endpoints in a
  # convenient place to use.
  #
  # @author Kent 'picat' Gruber
  class Client
    # @return [Shodanz::API::REST]
    attr_reader :rest_api
    # @return [Shodanz::API::Streaming]
    attr_reader :streaming_api
    # @return [Shodanz::API::Exploits]
    attr_reader :exploits_api

    # Create a new client to connect to any of the APIs.
    #
    # Optionally provide your Shodan API key, or the environment
    # variable SHODAN_API_KEY will be used.
    def initialize(key: ENV['SHODAN_API_KEY'])
      raise Shodanz::Errors::NoAPIKey if key.nil?

      # pass the given API key to each of the underlying clients
      #
      # Note: you can optionally change these API keys later, if you
      # had multiple for whatever reason. ;)
      #
      @rest_api      = Shodanz.api.rest.new(key: key)
      @streaming_api = Shodanz.api.streaming.new(key: key)
      @exploits_api  = Shodanz.api.exploits.new(key: key)
    end

    def host(ip, **params)
      rest_api.host(ip, **params)
    end

    def host_count(query = '', facets: {}, **params)
      rest_api.host_count(query, facets: facets, **params)
    end

    def host_search(query = '', facets: {}, page: 1, minify: true, **params)
      rest_api.host_search(query, facets: facets, page: page, minify: minify, **params)
    end

    def host_search_tokens(query = '', **params)
      rest_api.host_search(query, params)
    end

    def ports
      rest_api.ports
    end

    def protocols
      rest_api.protocols
    end

    def scan(*ips)
      rest_api.scan(ips)
    end

    def crawl_for(**params)
      rest_api.scan(params)
    end

    def scan_status(id)
      rest_api.scan_status(id)
    end

    def community_queries(**params)
      rest_api.community_queries(params)
    end

    def search_for_community_query(query, **params)
      rest_api.search_for_community_query(query, params)
    end

    def popular_query_tags(size = 10)
      rest_api.popular_query_tags(size)
    end

    def profile
      rest_api.profile
    end

    def resolve(*hostnames)
      rest_api.resolve(hostnames)
    end

    def reverse_lookup(*ips)
      rest_api.reverse_lookup(ips)
    end

    def http_headers
      rest_api.http_headers
    end

    def my_ip
      rest_api.my_ip
    end

    def honeypot_score(ip)
      rest_api.honeypot_score(ip)
    end

    def info
      rest_api.info
    end

    def exploit_search(query = '', page: 1, **params)
      exploits_api.search(query, page: page, **params)
    end

    def exploit_count(query = '', page: 1, **params)
      exploits_api.count(query, page: page, **params)
    end
  end
end
