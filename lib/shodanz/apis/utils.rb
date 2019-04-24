require_relative 'utils.rb'

module Shodanz
  module API
    module Utils
      # Perform a direct GET HTTP request to the REST API.
      def get(path, **params)
        Async do
          # param keys should all be strings
          params = params.transform_keys { |key| key.to_s }
          # make GET request to server, checking if query is needed to be passed
          if query = params.delete('query')
            resp = @internet.get("#{@url}#{path}?query=#{query}&key=#{@key}", params)
          else
            resp = @internet.get("#{@url}#{path}?key=#{@key}", params)
          end
          # parse all lines in the response body as JSON
          JSON.parse(resp.body.join)
        end.result
      end

      # Perform a direct POST HTTP request to the REST API.
      def post(path, **params)
        Async do
          # param keys should all be strings
          params = params.transform_keys { |key| key.to_s } 
          # make POST request to server
          resp = @internet.post("#{@url}#{path}?key=#{@key}", params)
          # parse all lines in the response body as JSON
          JSON.parse(resp.body.join)
        end.result
      end

      def slurp_stream(path, **params)
        Async do
          # param keys should all be strings
          params = params.transform_keys { |key| key.to_s } 
          # make POST request to server
          resp = @internet.get("#{@url}#{path}?key=#{@key}", params)

          resp.body.read.each_line do |line|
            yield JSON.parse(line)
          end
        end
      end
    end
  end
end