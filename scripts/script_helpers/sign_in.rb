# frozen_string_literal: true

module ScriptHelpers
  module SignIn
    def email_for_sign_in(selection, user_id = nil)
      if selection == 1
        User.find(user_id).email
      else
        puts 'User email?'
        gets.chomp
      end
    end

    def sign_in(email, env_url)
      uri = URI.parse("#{env_url}/auth/sign_in")
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json'
      request.body = "{\"email\": \"#{email}\", \"password\": \"Password1!\" }"

      req_options = {
        use_ssl: uri.scheme == 'https'
      }

      Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    end
  end
end
