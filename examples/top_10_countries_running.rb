$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shodanz'
require 'command_lion'
require 'yaml'
require 'pry'

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

CommandLion::App.run do
  name "Top 10 Countires Running a Product Using Shodan"

  command :product do
    description "Search for this given product."
    type :string
    flag "--product"

    # Check is Shodan Enviroemnt Variable Set
    before do
      unless ENV['SHODAN_API_KEY'] 
        puts "Need to set the 'SHODAN_API_KEY' enviroment variable before using this app!"
        exit 1 # [ ╯´･ω･]╯︵┸━┸) 
      end
      if argument.empty?
        puts "What kind of nonsense is this?! You need to provide some argument..."
        exit 1 # [ ╯ ﾟ▽ﾟ]╯︵┻━┻)
      end
    end

    # Do stuff.
    action do
      result = Top10.check(argument)
      if options[:json].given?
        puts JSON.pretty_generate(result)
      elsif options[:yaml].given?
        puts result.to_yaml
      else
        result.each do |country, count|
          puts "#{country}\t#{count}"
        end
      end
    end

    option :json do
      description "Use JSON as the format to output to STDOUT."
      flag "--json"
    end

    option :yaml do
      description "Use YAML as the format to output to STDOUT."
      flag "--yaml"
    end
  end
end
