$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "shodanz"
require "chart_js"

module Top10
  @rest_api = Shodanz.api.rest.new
  def self.check(product)
    begin
      @rest_api.host_count(product: product, facets: { country: 10 })["facets"]["country"].collect { |x| x.values }.to_h.invert
    rescue
      puts "Unable to succesffully check the Shodan API."
      exit 1
    end
  end
end

results = Top10.check("apache")

ChartJS.bar do
  file "top_10_apache.html"
  data do
    labels results.keys
    dataset "Countries" do
      color :random
      data results.values
    end 
  end
end
