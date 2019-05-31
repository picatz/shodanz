# frozen_string_literal: true

module Shodanz
  module Errors
    # A general Error from the Shodan API
    class Error < StandardError
    end

    # An error returned when the Shodan API is rate-limiting requests (1 per second)
    class RateLimited < Error
      def initialize(msg = 'Request rate limit reached (1 request/ second). Please wait a second before trying again and slow down your API calls.')
        super
      end
    end

    # An error returned when there is no informational available from the API.
    class NoInformation < Error
      def initialize(msg = 'No information available.')
        super
      end
    end

    # An error returned when here is no API key provided in the HTTP request to the API.
    class NoAPIKey < Error
      def initialize(msg = 'No API key has been found or provided! (setup your SHODAN_API_KEY environment variable)')
        super
      end
    end

    # An error returned when there is no query in the HTTP request provided to the API.
    class NoQuery < Error
      def initialize(msg = 'Empty search query.')
        super
      end
    end
  end
end
