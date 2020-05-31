# frozen_string_literal: true

Dir[Rails.root.join('scripts', 'script_helpers', '**', '*.rb')].sort.each { |f| require f }

module ScriptHelpers
  include ScriptHelpers::SignIn
  include ScriptHelpers::Data
  include ScriptHelpers::EnvSelection
  include ScriptHelpers::DisplayResults
end
