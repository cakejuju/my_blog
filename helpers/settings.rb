require 'settingslogic'

class Settings < Settingslogic
  # source './application.yml'
  source "./config/application_#{ENV['RACK_ENV']}.yml"
end

