# frozen_string_literal: true

require_relative 'apis/utils.rb'
require_relative 'apis/rest.rb'
require_relative 'apis/streaming.rb'
require_relative 'apis/exploits.rb'

module Shodanz
  # There are 3 APIs for accessing Shodan: the REST API,
  # the Streaming API and the Exploits API.

  # The REST API provides methods to search Shodan,
  # look up hosts, get summary information
  # on queries and a variety of utility methods to make
  # developing easier.
  #
  # The Streaming API provides a raw,
  # real-time feed of the data that Shodan is currently
  # collecting. There are several feeds that can be subscribed
  # to, but the data can't be searched or otherwise interacted
  # with; it's a live feed of data meant for large-scale
  # consumption of Shodan's information.
  #
  # The Exploits API provides access to several
  # exploit/vulnerability data sources. At the moment,
  # it searches across the following:
  #  - Exploit DB
  #  - Metasploit
  #  - Common Vulnerabilities and Exposures (CVE)
  #
  # @author Kent 'picat' Gruber
  module API
    # REST API class.
    def self.rest
      REST
    end

    # Streaming API class.
    def self.streaming
      Streaming
    end

    # Exploits API class.
    def self.exploits
      Exploits
    end
  end
end
