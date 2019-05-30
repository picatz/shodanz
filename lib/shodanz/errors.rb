# frozen_string_literal: true

module Shodanz
  module Errors
    class Error < StandardError
    end
    
    class RateLimited < Error
      def initialize(msg = 'Request rate limit reached (1 request/ second). Please wait a second before trying again and slow down your API calls.')
        super
      end
    end

    class NoInformation < Error
      def initialize(msg = 'No information available.')
        super
      end
    end

    class NoAPIKey < Error
      def initialize(msg = 'No API key has been found or provided! (setup your SHODAN_API_KEY environment variable)')
        super
      end
    end

    class NoQuery < Error
      def initialize(msg = 'Empty search query.')
        super
      end
    end
  end
end
