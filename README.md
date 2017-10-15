# Shodanz

A modern Ruby [gem](https://rubygems.org/) for [Shodan](https://www.shodan.io/), the world's first search engine for Internet-connected devices.

## Installation

    $ gem install shodanz

## Usage

```ruby
require "shodanz"

rest_api      = Shodanz.api.rest.new
streaming_api = Shodanz.api.streaming.new
exploits_api  = Shodanz.api.exploits.new
```

## REST API

The REST API provides methods to search Shodan, look up hosts, get summary information on queries and a variety of utility methods to make developing easier.

### Shodan Search Methods

Search'n for stuff, are 'ya?

#### Host Information

Returns all services that have been found on the given host IP.

```ruby
rest_api.host("8.8.8.8")                # Default
rest_api.host("8.8.8.8", history: true) # All historical banners should be returned.
rest_api.host("8.8.8.8", minify: true)  # Only return the list of ports and the general host information, no banners. 
```

#### Host Search

Search Shodan using the same query syntax as the website and use facets to get summary information for different properties.

```ruby
rest_api.host_search("mongodb")
rest_api.host_search("nginx")
rest_api.host_search("apache", after: "1/12/16")
rest_api.host_search("ssh", port: 22, page: 1)
rest_api.host_search("ssh", port: 22, page: 2)
rest_api.host_search("ftp", port: 21, facets: { link: "Ethernet or modem" })
```

#### Search Shodan without Results

This method behaves identical to `host_search` with the only difference that this method does not return any host results, it only returns the total number of results that matched the query and any facet information that was requested. As a result this method does not consume query credits.

```ruby
rest_api.host_count("apache")
rest_api.host_count("apache", country: "US")
rest_api.host_count("apache", country: "US", state: "MI")
rest_api.host_count("apache", country: "US", state: "MI", city: "Detroit") 
rest_api.host_count("apache", country: "US", state: "MI", city: "Detroit") 
rest_api.host_count("nginx".  facets: { country: 5 })
rest_api.host_count("apache". facets: { country: 5 })
```

#### Scan Targets

Use this method to request Shodan to crawl an IP or netblock.

```ruby
rest_api.scan("8.8.8.8")
```

#### Crawl Internet for Port

Use this method to request Shodan to crawl the Internet for a specific port.

This method is restricted to security researchers and companies with a Shodan Data license. To apply for access to this method as a researcher, please email `jmath@shodan.io` with information about your project. Access is restricted to prevent abuse.

```ruby
rest_api.crawl_for(port: 80, protocol: "http")
```

#### List Community Queries

Use this method to obtain a list of search queries that users have saved in Shodan.

```ruby
rest_api.community_queries
rest_api.community_queries(page: 2)
rest_api.community_queries(sort: "votes")
rest_api.community_queries(sort: "votes", page: 2)
rest_api.community_queries(order: "asc")
rest_api.community_queries(order: "desc")
```

#### Search Community Queries

Use this method to search the directory of search queries that users have saved in Shodan.

```ruby
rest_api.search_for_community_query("the best")
rest_api.search_for_community_query("the best", page: 2)
```

#### Popular Community Query Tags

Use this method to obtain a list of popular tags for the saved search queries in Shodan.

```ruby
rest_api.popular_query_tags
rest_api.popular_query_tags(20)
```

#### Protocols

This method returns an object containing all the protocols that can be used when launching an Internet scan.

```ruby
rest_api.protocols
```

#### Ports

This method returns a list of port numbers that the Shodan crawlers are looking for.

```ruby
rest_api.ports
```

#### Account Profile

Returns information about the Shodan account linked to this API key.

```ruby
rest_api.profile
```

#### DNS Lookup

Look up the IP address for the provided list of hostnames.

```ruby
rest_api.resolve("google.com")
rest_api.resolve("google.com", "bing.com")
```

#### Reverse DNS Lookup

Look up the hostnames that have been defined for the given list of IP addresses.

```ruby
rest_api.reverse_lookup("74.125.227.230")
rest_api.reverse_lookup("74.125.227.230", "204.79.197.200")
```

#### HTTP Headers

Shows the HTTP headers that your client sends when connecting to a webserver.

```ruby
rest_api.http_headers
```

#### Your IP Address

Get your current IP address as seen from the Internet.

```ruby
rest_api.my_ip
```

#### Honeypot Score

Calculates a honeypot probability score ranging from 0 (not a honeypot) to 1.0 (is a honeypot).

```ruby
rest_api.honeypot_score('8.8.8.8')
```

#### API Plan Information

```ruby
rest_api.info
```

### Streaming API

The Streaming API is an HTTP-based service that returns a real-time stream of data collected by Shodan.

#### Banners

This stream provides ALL of the data that Shodan collects. Use this stream if you need access to everything and/ or want to store your own Shodan database locally. If you only care about specific ports, please use the Ports stream.

```ruby
streaming_api.banners do |data|
  # do something with banner data
  puts data
end
```

#### Banners Filtered by ASN

This stream provides a filtered, bandwidth-saving view of the Banners stream in case you are only interested in devices located in certain ASNs.

```ruby
streaming_api.banners_within_asns(3303, 32475) do |data|
  # do something with banner data
  puts data
end
```

#### Banners Filtered by Country

This stream provides a filtered, bandwidth-saving view of the Banners stream in case you are only interested in devices located in certain countries.

```ruby
streaming_api.banners_within_countries("DE", "US", "JP") do |data|
  # do something with banner data
  puts data
end
```

#### Banners Filtered by Ports 

Only returns banner data for the list of specified ports. This stream provides a filtered, bandwidth-saving view of the Banners stream in case you are only interested in a specific list of ports.

```ruby
streaming_api.banners_on_ports(21, 22, 80) do |data| 
  # do something with banner data
  puts data
end
```

#### Banners by Network Alerts

Subscribe to banners discovered on all IP ranges described in the network alerts.

```ruby
streaming_api.alerts do |data|
  # do something with banner data
  puts data
end
```

#### Banner Filtered by Alert ID

Subscribe to banners discovered on the IP range defined in a specific network alert.

```ruby
streaming_api.alert("HKVGAIRWD79Z7W2T") do |data|
  # do something with banner data
  puts data
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Shodanz project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/shodanz/blob/master/CODE_OF_CONDUCT.md).
