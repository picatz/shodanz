module Shodanz
  class Client
    # Create a new client to connect to any of the APIs.
    def initialize
      @rest_api      = Shodanz.api.rest.new
      @streaming_api = Shodanz.api.streaming.new
      @exploits_api  = Shodanz.api.exploits.new  
    end

    def rest_api
      @rest_api
    end

    def streaming_api
      @streaming_api
    end

    def exploits_api
      @exploits_api
    end
  end
end
