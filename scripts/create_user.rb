# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'faker'
require_relative 'script_helpers/script_helpers'

include ScriptHelpers

# Select environment to test
selection = get_env_selection

# Determine base URL for environment selection
env_url = base_url_for_env(selection)

# Send request to API and display response
uri = URI.parse("#{env_url}/auth")
request = Net::HTTP::Post.new(uri)
request.content_type = 'application/json'
request.body = JSON.dump({
                           'email' => Faker::Internet.email,
                           'first_name' => Faker::Name.first_name,
                           'last_name' => Faker::Name.first_name,
                           'username' => Faker::Internet.username,
                           'password' => 'Password1!',
                           'password_confirmation' => 'Password1!'
                         })

req_options = {
  use_ssl: uri.scheme == 'https'
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

display_results(response)
