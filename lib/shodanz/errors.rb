module Shodanz
    module Errors
        class RateLimited < StandardError
            def initialize(msg="Request rate limit reached (1 request/ second). Please wait a second before trying again and slow down your API calls.")
                super
            end
        end
        
        class NoInformation < StandardError
            def initialize(msg="No information available.")
                super
            end
        end
    end
end