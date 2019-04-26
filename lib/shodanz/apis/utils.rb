require_relative 'utils.rb'

module Shodanz
  module API
    module Utils
      # Perform a direct GET HTTP request to the REST API.
      def get(path, **params)
        return sync_get(path, params) unless Async::Task.current? 
        async_get(path, params)
      end

      # Perform a direct POST HTTP request to the REST API.
      def post(path, **params)
        return sync_post(path, params) unless Async::Task.current? 
        async_post(path, params)
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

      private

      def async_get(path, **params)
        Async::Task.current.async do 
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
        ensure
          resp.close unless resp.nil?
        end
      end

      def sync_get(path, **params)
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
        ensure
          resp.close unless resp.nil?
        end.result
      end

      def async_post(path, **params)
        Async::Task.current.async do 
          # param keys should all be strings
          params = params.transform_keys { |key| key.to_s } 
          # make POST request to server
          resp = @internet.post("#{@url}#{path}?key=#{@key}", params)
          # parse all lines in the response body as JSON
          JSON.parse(resp.body.join)
        ensure
          resp.close unless resp.nil?
        end
      end

      def sync_post(path, **params)
        Async do 
          # param keys should all be strings
          params = params.transform_keys { |key| key.to_s } 
          # make POST request to server
          resp = @internet.post("#{@url}#{path}?key=#{@key}", params)
          # parse all lines in the response body as JSON
          JSON.parse(resp.body.join)
        ensure
          resp.close unless resp.nil?
        end.result
      end

      def async_slurp_stream(path, **params)
        Async::Task.current.async do 
          # param keys should all be strings
          params = params.transform_keys { |key| key.to_s } 
          # make GET request to server
          resp = @internet.get("#{@url}#{path}?key=#{@key}", params)
          # read body line-by-line
          until resp.body.empty?
            resp.body.read.each_line do |line|
              next if line.strip.empty?
              yield JSON.parse(line)
            end
          end
        ensure
          resp.close unless resp.nil?
        end
      rescue => error
        binding.pry
      end

      def sync_slurp_stream(path, **params)
        resp = nil
        Async do
          # param keys should all be strings
          params = params.transform_keys { |key| key.to_s } 
          # make GET request to server
          resp = @internet.get("#{@url}#{path}?key=#{@key}", params)
          # read body line-by-line
          until resp.body.empty? 
            resp.body.read.each_line do |line|
              yield JSON.parse(line)
            end
          end
        ensure
          resp.close unless resp.nil?
        end
      end
    end
  end
end
