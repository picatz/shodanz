$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shodanz'

trap "SIGINT" do
  puts # add some room
  exit 0
end

streaming_api = Shodanz.api.streaming.new

stats = Hash.new(0)

streaming_api.banners do |banner|
  begin
    product = banner['product']
    puts "#{stats[product] += 1} #{product}"
  rescue
    stats[:unknown] += 1
  end
end
