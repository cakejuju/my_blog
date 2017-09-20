
# https://github.com/e2/ruby_dep/wiki/Disabling-warnings
ENV['RUBY_DEP_GEM_SILENCE_WARNINGS'] = '1' # Disabling warnings

source 'https://gems.ruby-china.org'

gem 'sinatra'

gem 'activerecord'

gem "sinatra-activerecord"

gem "sqlite3", :platform => [:ruby, :mswin, :mingw]

gem 'rake'

gem 'puma'

gem 'faraday'

gem 'typhoeus', '~> 1.1'

gem 'jwt'

gem 'sinatra-contrib', '~> 2.0' # cookie

gem 'redcarpet' # convert markdown to html string

gem 'upyun', '~> 1.0.8' # 又拍云 SDK

gem 'settingslogic' # parse yml to hash

group :development do
  gem "rerun"  # change the file and auto reload
end

group :test do
  gem "minitest"
  gem 'rack-test'
  gem 'database_cleaner'
end