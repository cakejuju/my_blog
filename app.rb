require 'sinatra/base'
require "sinatra/cookies"
require 'active_record'
require "sinatra/activerecord"
require "sqlite3"
require 'jwt' # json web token
require 'redcarpet'
require 'upyun' # 又拍云 SDK



# p res
# => {:sign=>"229ddc675e70d734c703502b1c12668e", :code=>200, :file_size=>5239, :url=>"/2017/05/18/yace_jiami.rb", :time=>1495099874, :message=>"ok", :mimetype=>"text/plain; charset=utf-8", :request_id=>"15f8307656c8a18741dcdc9925c3cde2"}

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
    response['Access-Control-Allow-Origin'] = '*' 
    # response['Access-Control-Allow-Origin'] = 'http://192.168.31.20:8080' 
    next unless request.post?

    begin
      read_body = request.body.read

      @params = JSON.parse(read_body).with_indifferent_access 

      content_type :json    
    rescue JSON::ParserError => e
      @params = params.with_indifferent_access 

      content_type :json
    end
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



