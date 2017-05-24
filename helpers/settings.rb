require 'settingslogic'

class Settings < Settingslogic
  # source './application.yml'
  source "./config/#{ENV['RACK_ENV']}.yml"
end

