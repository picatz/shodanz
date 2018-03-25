module Shodanz
  # General client container class for all three
  # of Shodan's available API endpoints in a
  # convient place to use.
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
    def initialize
      @rest_api      = Shodanz.api.rest.new
      @streaming_api = Shodanz.api.streaming.new
      @exploits_api  = Shodanz.api.exploits.new
    end
  end
end
