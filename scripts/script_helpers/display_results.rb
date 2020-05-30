# frozen_string_literal: true

module ScriptHelpers
  module DisplayResults
    def display_results(response)
      puts "Response code => #{response.code}"
      puts 'Response body =>'
      puts JSON.pretty_generate(JSON.parse(response.body))
    end
  end
end
