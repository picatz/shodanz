$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'async'
require 'shodanz'

client = Shodanz.client.new

webservers = ['apache', 'nginx', 'caddy', 'lighttpd', 'cherokee'] 

# we can use methods sequentially
started = Time.now.sec
webservers.each do |webserver|
  # make HTTP request
  client.rest_api.host_search(webserver)
  # print webserver to STDOUT
  puts webserver
end
puts "Sequential took #{Time.now.sec - started} seconds"

# we can also use methods asyncronously
started = Time.now.sec
Async do
  webservers.each do |webserver|
    # make HTTP request
    client.rest_api.host_search(webserver)
    # print webserver to STDOUT
    puts webserver
  end
end
puts "Asyncronous took #{Time.now.sec - started} seconds"
