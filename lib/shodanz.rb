require 'unirest'
require 'oj'
require 'shodanz/version'
require 'shodanz/api'
require 'shodanz/client'

# Shodanz is a modern Ruby gem for Shodan, the world's
# first search engine for Internet-connected devices.
module Shodanz
  # Shortcut for {Shodanz::API}
  def self.api
    API
  end

  # Shortcut for {Shodanz::Client}
  def self.client
    Client
  end
end
