$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shodanz'
require 'pry'

rest_api      = Shodanz.api.rest.new
streaming_api = Shodanz.api.streaming.new
exploits_api  = Shodanz.api.exploits.new

binding.pry
