$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'async'
require 'shodanz'

`clear` # clear the screen

client = Shodanz.client.new

stats = Hash.new(0)

ports    = [21, 22, 80, 443]
services = ['ftp', 'ssh', 'http', 'https']

ports_with_service_names = ports.zip(services)

Async do
  # collect banners for ports
  ports_with_service_names.each do |port, service|
    client.streaming_api.banners_on_port(port) do |_|
      puts "#{stats[port] += 1} #{service}"
    end
  end
end
