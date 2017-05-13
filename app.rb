require 'sinatra/base'
require "sinatra/cookies"
require 'active_record'
require "sinatra/activerecord"
require "sqlite3"
require 'jwt' # json web token
require 'redcarpet'

# development 启动方式 rerun ./bin/puma
# p Gem.loaded_specs.values.map {|x| "#{x.name} #{x.version}"}
# p ENV

# set :database, {adapter: "sqlite3", database: "my_blog_#{ENV['env']}.sqlite3"}

# 使用sqlite3 创建数据库 => sqlite3 DatabaseName.db
# run sinatra console by => $ irb -r ./app.rb
ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    database: './my_blog_development.sqlite2',
    reaping_frequency: 4,
    pool:     6   
)

# require models
Dir['./models/*.rb'].each { |file| require_relative file }

# p ActiveRecord::Base.connection.tables
# modular the Sinatra app
# can run it in config.ru


class MyApp < Sinatra::Application
  set :protection, :except => :json_csrf # 使前端ajax可以跨域访问

  before do
    @params = JSON.parse(request.body.read).with_indifferent_access 

    content_type :json
  end 

  get '/get_some_data' do
    content_type :json

    {hi: 'this is your data'}.to_json
  end

  get '/hello/:name' do |n|
    # 匹配"GET /hello/foo" 和 "GET /hello/bar"
    # params[:name] 的值是 'foo' 或者 'bar'
    # n 中存储了 params['name']
    "Hello #{n}! and #{params['name']}"
  end
end

Dir['./helpers/*.rb'].each { |file| require_relative file }
# require_relative './helpers/api_helper'
# 导入所有 api routes 这是使用打开类添加路由
Dir['./api_routes/*.rb'].each { |file| require_relative file }



