$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shodanz'

# clean CTL+C exit
trap "SIGINT" do
  exit 0
end

# streaming API client
streaming_api = Shodanz.api.streaming.new

# every key's value stats at 0
stats = Hash.new(0)

# collect banners 
streaming_api.banners do |banner|
  product = banner['product']
  puts "#{stats[product] += 1} #{product}"
end
