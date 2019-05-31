# frozen_string_literal: true

require 'json'
require 'async/rest/representation'
require 'async/rest/wrapper/json'
require 'protocol/http/reference'

module Shodanz
  module API
    module Wrapper
      class JSON < Async::REST::Wrapper::JSON
        def process_response(request, response)
          if content_type = response.headers['content-type']
            if content_type.start_with? @content_type
              if body = response.body
                response.body = Parser.new(body)
              end
            else
              warn "Unknown content type: #{content_type}!"
            end
          end

          return response
        end

        class Parser < ::Protocol::HTTP::Body::Wrapper
          def join
            ::JSON.parse(super, symbolize_names: false)
          end
        end
      end
    end

    # Handle the general representation of the Shodanz API.
    #
    # @author Samuel Williams
    class Representation < Async::REST::Representation
      RATELIMIT = /rate limit reached/i
      NOINFO = /no information available/i
      NOQUERY = /empty search query/i

      # Check if there's an API key.
      def key?
        @resource.parameters.include?('key')
      end

      def process_response(request, response)
        unless response.success?
          raise Shodanz::Errors::Error, response.read
        end

        message = super

        if message.is_a?(Hash) and error = message['error']
          case error
          when RATELIMIT
            raise Shodanz::Errors::RateLimited, error
          when NOINFO
            raise Shodanz::Errors::NoInformation, error
          when NOQUERY
            raise Shodanz::Errors::NoQuery, error
          else
            raise Shodanz::Errors::Error, error
          end
        end

        return message
      end

      def representation
        Representation
      end

      def represent(metadata, attributes)
        resource = @resource.with(path: attributes[:id])

        representation.new(resource, metadata: metadata, value: attributes)
      end

      def represent_message(message)
        represent(message.headers, message.result)
      end

      def to_hash
        if value.is_a?(Hash)
          return value
        end
      end

      def [] key
        if hash = to_hash
          hash[key.to_sym]
        end
      end
    end
  end
end
