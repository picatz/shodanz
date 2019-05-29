# fronzen_string_literal: true

module Shodanz
  module API
    # Utils provides simply get, post, and slurp_stream functionality
    # to the client. Under the hood they support both async and non-async
    # usage. You should basically never need to use these methods directly.
    #
    # @author Kent 'picat' Gruber
    module Utils
      # Response ensures the parsed JSON body doesn't use symbols for key names.
      class Response < Async::REST::Representation
        class Parser < Protocol::HTTP::Body::Wrapper
          def join
            ::JSON.parse(super, symbolize_names: false)
          end
        end

        def process_response(request, response)
          if body = response.body
            response.body = Parser.new(body)
          end

          return response
        end
      end

      # Perform a direct GET HTTP request to the REST API.
      def get(path, **params)
        params = params.transform_keys(&:to_sym)

        params[:key] = @key

        task = Async::REST::Resource.for(@url) do |resource|
          handle_any_json_errors(resource.with(path: path, parameters: params).get(Response).value)
        end

        task.wait unless Async::Task.current?
      end

      # Perform a direct POST HTTP request to the REST API.
      def post(path, **params)
        params = params.transform_keys(&:to_sym)

        params[:key] = @key

        task = Async::REST::Resource.for(@url) do |resource|
          handle_any_json_errors(resource.with(path: path, parameters: params).post(Response).value)
        end

        task.wait unless Async::Task.current?
      end

      # Perform the main function of consuming the streaming API.
      def slurp_stream(path, **params)
        if Async::Task.current?
          async_slurp_stream(path, params) do |result|
            yield result
          end
        else
          sync_slurp_stream(path, params) do |result|
            yield result
          end
        end
      end

      def turn_into_query(params)
        filters = params.reject { |key, _| key == :query }
        filters.each do |key, value|
          params[:query] << " #{key}:#{value}"
        end
        params.select { |key, _| key == :query }
      end

      def turn_into_facets(facets)
        return {} if facets.nil?

        filters = facets.reject { |key, _| key == :facets }
        facets[:facets] = []
        filters.each do |key, value|
          facets[:facets] << "#{key}:#{value}"
        end
        facets[:facets] = facets[:facets].join(',')
        facets.select { |key, _| key == :facets }
      end

      private

      RATELIMIT = 'rate limit reached'
      NOINFO    = 'no information available'
      NOQUERY   = 'empty search query'

      def handle_any_json_errors(json)
        return json unless json.is_a?(Hash) && json.key?('error')

        raise Shodanz::Errors::RateLimited if json['error'].casecmp(RATELIMIT) >= 0
        raise Shodanz::Errors::NoInformation if json['error'].casecmp(NOINFO) >= 0
        raise Shodanz::Errors::NoQuery if json['error'].casecmp(NOQUERY) >= 0

        json
      end

      def slurper(path, **params)
        # param keys should all be strings
        params = params.transform_keys(&:to_s)
        # check if limit
        if (limit = params.delete('limit'))
          counter = 0
        end
        # make GET request to server
        resp = @internet.get("#{@url}#{path}?key=#{@key}", params)
        # read body line-by-line
        until resp.body.nil? || resp.body.empty?
          resp.body.read.each_line do |line|
            next if line.strip.empty?

            yield JSON.parse(line)
            if limit
              counter += 1
              resp.close if counter == limit
            end
          end
        end
      ensure
        resp&.close
      end

      def async_slurp_stream(path, **params)
        Async::Task.current.async do
          slurper(path, params) { |data| yield data }
        end
      end

      def sync_slurp_stream(path, **params)
        Async do
          slurper(path, params) { |data| yield data }
        end.wait
      end
    end
  end
end
