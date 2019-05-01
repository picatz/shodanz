# frozen_string_literal: true

require 'json'
require 'async'
require 'async/http/internet'
require 'shodanz/version'
require 'shodanz/errors'
require 'shodanz/api'
require 'shodanz/client'

# disable async logs by default
Async.logger.level = 4

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
