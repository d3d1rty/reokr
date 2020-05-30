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
puts 'User ID to update?'
user_id = gets.chomp

# Load data to send in request
data = load_data get_filename

# Authenticate user
auth_response = sign_in(email_for_sign_in(selection, user_id), env_url)
abort 'Sign in unsuccessful' unless auth_response.code.to_i == 200

# Send request to API and display response
uri = URI.parse("#{env_url}/users/#{user_id}")
request = Net::HTTP::Patch.new(uri)
request.content_type = 'application/json'
request['Access-Token'] = auth_response['Access-Token']
request['Client'] = auth_response['Client']
request['Uid'] = auth_response['Uid']
request.body = JSON.dump(data)

req_options = {
  use_ssl: uri.scheme == 'https'
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

display_results(response)
