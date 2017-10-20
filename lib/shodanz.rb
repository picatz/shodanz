require "unirest"
require "oj"
require "shodanz/version"
require "shodanz/api"
require "shodanz/client"

module Shodanz
  def self.api
    API
  end
  def self.client
    Client
  end
end
