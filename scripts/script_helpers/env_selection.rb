# frozen_string_literal: true

module ScriptHelpers
  module EnvSelection
    def get_env_selection
      puts 'Run test in local (1), dev (2), or staging (3) environment?'
      selection = gets.chomp.to_i
      abort 'Selection invalid. Try again.' unless [1, 2, 3].include?(selection)

      selection
    end

    def base_url_for_env(selection)
      case selection
      when 1
        return 'http://localhost:3000'
      when 2
        return 'https://reokr-dev.herokuapp.com'
      when 3
        return 'https://reokr-staging.herokuapp.com'
      end
    end
  end
end
