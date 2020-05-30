# frozen_string_literal: true

module ScriptHelpers
  module Data
    def get_filename
      puts 'Data filename to use for update?'
      gets.chomp
    end

    def load_data(filename)
      file = File.read "scripts/data/#{filename}"
      JSON.parse(file)
    rescue StandardError
      puts 'File not found.'
      exit 1
    end
  end
end
