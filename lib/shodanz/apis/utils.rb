# fronzen_string_literal: true

module Shodanz
  module API
    # Utils provides some common methods used in the REST
    # and Exploits API. You shouldn't need to use this module directly.
    #
    # @author Kent 'picat' Gruber
    module Utils
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

      def async(&block)
        if task = Async::Task.current?
          yield
        else
          Async do
            result = yield

            self.close

            result
          end.wait
        end
      end

      def get_value(path, parameters = nil)
        async do
          Representation.new(@resource.with(path: path, parameters: parameters), wrapper: @wrapper).value
        end
      end
    end
  end
end
