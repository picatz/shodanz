# frozen_string_literal: true

module Shodanz
  module Errors
    class RateLimited < StandardError
      def initialize(msg = 'Request rate limit reached (1 request/ second). Please wait a second before trying again and slow down your API calls.')
        super
      end
    end

    class NoInformation < StandardError
      def initialize(msg = 'No information available.')
        super
      end
    end

    class NoAPIKey < StandardError
      def initialize(msg = 'No API key has been found or provided! ( setup your SHODAN_API_KEY environment varialbe )')
        super
      end
    end

    class NoQuery < StandardError
      def initialize(msg = 'Empty search query.')
        super
      end
    end
  end
end
