# frozen_string_literal: true

require 'rest-client'
require 'json'

return if ENV['MAILTRAP_API_TOKEN'].nil?

response = RestClient::Resource.new("https://mailtrap.io/api/v1/inboxes.json?api_token=#{ENV['MAILTRAP_API_TOKEN']}").get
inbox = JSON.parse(response)[0]

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  user_name: inbox['username'],
  password: inbox['password'],
  address: inbox['domain'], domain: inbox['domain'],
  port: inbox['smtp_ports'][0],
  authentication: :plain
}
