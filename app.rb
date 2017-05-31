require 'sinatra/base'
require "sinatra/cookies"
require 'active_record'
require "sinatra/activerecord"
require "sqlite3"
require 'jwt' # json web token
require 'redcarpet'
require 'upyun' # 又拍云 SDK


# 使用sqlite3 创建数据库 => ./bin/rake db:create RACK_ENV=#{RACK_ENV}

# run sinatra console by => $ irb -r ./app.rb

# modular the Sinatra app
# can run it in config.ru

class MyApp < Sinatra::Application
  set :protection, :except => :json_csrf # 使前端ajax可以跨域访问

  before do
    response['Access-Control-Allow-Origin'] = '*' # 跨域

    next unless request.post? # only for post request
    # read post requests parmas to hash
    begin
      read_body = request.body.read

      @params = JSON.parse(read_body).with_indifferent_access 

      content_type :json    
    rescue JSON::ParserError => e
      @params = params.with_indifferent_access 

      content_type :json
    end
  end
end


Dir['./helpers/*.rb'].each { |file| require_relative file }

env = ENV['RACK_ENV'] ? ENV['RACK_ENV'] : 'development'

# TODO 数据库配置从 config/database.yml 读取
ActiveRecord::Base.establish_connection(
    adapter:           "sqlite3",
    database:          "./db/my_blog_#{env}.sqlite3",
    reaping_frequency: 4,
    pool:              6   
)

# 导入所有 api routes 这是使用打开类添加路由
Dir['./api_routes/*.rb'].each { |file| require_relative file }
Dir['./api_routes/admin/*.rb'].each { |file| require_relative file }
# require models
Dir['./models/*.rb'].each { |file| require_relative file }








