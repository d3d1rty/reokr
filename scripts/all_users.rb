# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require_relative 'script_helpers/script_helpers'

include ScriptHelpers

# Select environment to test
selection = get_env_selection

# Determine base URL for environment selection
env_url = base_url_for_env(selection)

# User ID for operation
puts 'User ID for login?'
user_id = gets.chomp

# Authenticate user
auth_response = sign_in(email_for_sign_in(selection, user_id), env_url)
abort 'Sign in unsuccessful' unless auth_response.code.to_i == 200

uri = URI.parse("#{env_url}/graphql")
request = Net::HTTP::Post.new(uri)
request.content_type = 'application/json'
request["Connection"] = "keep-alive"
request["Accept"] = "application/json"
request['Access-Token'] = auth_response['Access-Token']
request['Client'] = auth_response['Client']
request['Uid'] = auth_response['Uid']
req_options = {
  use_ssl: uri.scheme == 'https'
}

request.body = JSON.dump({
  "query": "query {
    allUsers {
      id
      email
      firstName
      lastName
      username
      imageUrl
      bio
    }
  }"
})

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

puts "Response code => #{response.code}"
puts "Response body => \n#{response.body}"
