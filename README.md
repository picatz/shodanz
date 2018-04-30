# Shodanz

A modern Ruby [gem](https://rubygems.org/) for [Shodan](https://www.shodan.io/), the world's first search engine for Internet-connected devices.

## Installation

    $ gem install shodanz

## Usage

```ruby
require "shodanz"

client = Shodanz.client.new(key: "YOUR_API_KEY")
```
> You can also set the `SHODAN_API_KEY` environment variable instead of passing the API key as an argument when creating a client.

## REST API

The REST API provides methods to search Shodan, look up hosts, get summary information on queries and a variety of utility methods to make developing easier. Refer to the [REST API](https://developer.shodan.io/api) documentation for more ideas on how to use it.

### Shodan Search Methods

Search'n for stuff, are 'ya?

#### Host Information

Returns all services that have been found on the given host IP.

```ruby
client.rest_api.host("8.8.8.8")                # Default
client.rest_api.host("8.8.8.8", history: true) # All historical banners should be returned.
client.rest_api.host("8.8.8.8", minify: true)  # Only return the list of ports and the general host information, no banners. 
```

#### Host Search

Search Shodan using the same query syntax as the website and use facets to get summary information for different properties.

```ruby
client.rest_api.host_search("mongodb")
client.rest_api.host_search("nginx")
client.rest_api.host_search("apache", after: "1/12/16")
client.rest_api.host_search("ssh", port: 22, page: 1)
client.rest_api.host_search("ssh", port: 22, page: 2)
client.rest_api.host_search("ftp", port: 21, facets: { link: "Ethernet or modem" })
```

#### Search Shodan without Results

This method behaves identical to `host_search` with the only difference that this method does not return any host results, it only returns the total number of results that matched the query and any facet information that was requested. As a result this method does not consume query credits.

```ruby
client.rest_api.host_count("apache")
client.rest_api.host_count("apache", country: "US")
client.rest_api.host_count("apache", country: "US", state: "MI")
client.rest_api.host_count("apache", country: "US", state: "MI", city: "Detroit") 
client.rest_api.host_count("nginx",  facets: { country: 5 })
client.rest_api.host_count("apache", facets: { country: 5 })
```

#### Scan Targets

Use this method to request Shodan to crawl an IP or netblock.

```ruby
client.rest_api.scan("8.8.8.8")
```

#### Crawl Internet for Port

Use this method to request Shodan to crawl the Internet for a specific port.

This method is restricted to security researchers and companies with a Shodan Data license. To apply for access to this method as a researcher, please email `jmath@shodan.io` with information about your project. Access is restricted to prevent abuse.

```ruby
client.rest_api.crawl_for(port: 80, protocol: "http")
```

#### List Community Queries

Use this method to obtain a list of search queries that users have saved in Shodan.

```ruby
client.rest_api.community_queries
client.rest_api.community_queries(page: 2)
client.rest_api.community_queries(sort: "votes")
client.rest_api.community_queries(sort: "votes", page: 2)
client.rest_api.community_queries(order: "asc")
client.rest_api.community_queries(order: "desc")
```

#### Search Community Queries

Use this method to search the directory of search queries that users have saved in Shodan.

```ruby
client.rest_api.search_for_community_query("the best")
client.rest_api.search_for_community_query("the best", page: 2)
```

#### Popular Community Query Tags

Use this method to obtain a list of popular tags for the saved search queries in Shodan.

```ruby
client.rest_api.popular_query_tags
client.rest_api.popular_query_tags(20)
```

#### Protocols

This method returns an object containing all the protocols that can be used when launching an Internet scan.

```ruby
client.rest_api.protocols
```

#### Ports

This method returns a list of port numbers that the Shodan crawlers are looking for.

```ruby
client.rest_api.ports
```

#### Account Profile

Returns information about the Shodan account linked to this API key.

```ruby
client.rest_api.profile
```

#### DNS Lookup

Look up the IP address for the provided list of hostnames.

```ruby
client.rest_api.resolve("google.com")
client.rest_api.resolve("google.com", "bing.com")
```

#### Reverse DNS Lookup

Look up the hostnames that have been defined for the given list of IP addresses.

```ruby
client.rest_api.reverse_lookup("74.125.227.230")
client.rest_api.reverse_lookup("74.125.227.230", "204.79.197.200")
```

#### HTTP Headers

Shows the HTTP headers that your client sends when connecting to a webserver.

```ruby
client.rest_api.http_headers
```

#### Your IP Address

Get your current IP address as seen from the Internet.

```ruby
client.rest_api.my_ip
```

#### Honeypot Score

Calculates a honeypot probability score ranging from 0 (not a honeypot) to 1.0 (is a honeypot).

```ruby
client.rest_api.honeypot_score('8.8.8.8')
```

#### API Plan Information

```ruby
client.rest_api.info
```

### Streaming API

The Streaming API is an HTTP-based service that returns a real-time stream of data collected by Shodan. Refer to the [Streaming API](https://developer.shodan.io/api/stream) documentation for more ideas on how to use it.
#### Banners

This stream provides ALL of the data that Shodan collects. Use this stream if you need access to everything and/ or want to store your own Shodan database locally. If you only care about specific ports, please use the Ports stream.

```ruby
client.streaming_api.banners do |data|
  # do something with banner data
  puts data
end
```

#### Banners Filtered by ASN

This stream provides a filtered, bandwidth-saving view of the Banners stream in case you are only interested in devices located in certain ASNs.

```ruby
client.streaming_api.banners_within_asns(3303, 32475) do |data|
  # do something with banner data
  puts data
end
```

#### Banners Filtered by Country

This stream provides a filtered, bandwidth-saving view of the Banners stream in case you are only interested in devices located in certain countries.

```ruby
client.streaming_api.banners_within_countries("DE", "US", "JP") do |data|
  # do something with banner data
  puts data
end
```

#### Banners Filtered by Ports 

Only returns banner data for the list of specified ports. This stream provides a filtered, bandwidth-saving view of the Banners stream in case you are only interested in a specific list of ports.

```ruby
client.streaming_api.banners_on_ports(21, 22, 80) do |data| 
  # do something with banner data
  puts data
end
```

#### Banners by Network Alerts

Subscribe to banners discovered on all IP ranges described in the network alerts.

```ruby
client.streaming_api.alerts do |data|
  # do something with banner data
  puts data
end
```

#### Banner Filtered by Alert ID

Subscribe to banners discovered on the IP range defined in a specific network alert.

```ruby
client.streaming_api.alert("HKVGAIRWD79Z7W2T") do |data|
  # do something with banner data
  puts data
end
```

### Exploits API

The Exploits API provides access to several exploit/ vulnerability data sources. Refer to the [Exploits API](https://developer.shodan.io/api/exploits/rest) documentation for more ideas on how to use it.

#### Search

Search across a variety of data sources for exploits and use facets to get summary information.

```ruby
client.exploits_api.search("python")             # Search for Snek vulns.
client.exploits_api.search(post: 22)             # Port number for the affected service if the exploit is remote.
client.exploits_api.search(type: "shellcode")    # A category of exploit to search for.
client.exploits_api.search(osvdb: "100007")      # Open Source Vulnerability Database ID for the exploit.
```

#### Count

This method behaves identical to the Exploits API `search` method with the difference that it doesn't return any results.

```ruby
client.exploits_api.count("python")             # Count Snek vulns.
client.exploits_api.count(port: 22)             # Port number for the affected service if the exploit is remote.
client.exploits_api.search(type: "shellcode")   # A category of exploit to search for.
client.exploits_api.count(osvdb: "100007")      # Open Source Vulnerability Database ID for the exploit.
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
