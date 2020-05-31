# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

puts 'Run test in local (1), dev (2), or staging (3) environment?'
selection = gets.chomp.to_i
abort 'Selection invalid. Try again.' unless [1, 2, 3].include?(selection)

puts 'User ID to show?'
user_id = gets.chomp

case selection
when 1
  env_url = "http://localhost:3000/users/#{user_id}"
when 2
  env_url = "https://reokr-dev.herokuapp.com/users/#{user_id}"
when 3
  env_url = "https://reokr-staging.herokuapp.com/users/#{user_id}"
end

uri = URI.parse(env_url)
request = Net::HTTP::Get.new(uri)
request.content_type = 'application/json'
req_options = {
  use_ssl: uri.scheme == 'https'
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

puts "Response code => #{response.code}"
puts "Response body => \n#{response.body}"
