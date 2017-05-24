require 'sinatra/base'
require "sinatra/cookies"
require 'active_record'
require "sinatra/activerecord"
require "sqlite3"
require 'jwt' # json web token
require 'redcarpet'
require 'upyun' # 又拍云 SDK


# development 启动方式 rerun ./bin/puma
# p Gem.loaded_specs.values.map {|x| "#{x.name} #{x.version}"}



# 使用sqlite3 创建数据库 => sqlite3 DatabaseName.db
# run sinatra console by => $ irb -r ./app.rb


class MyApp < Sinatra::Application
  set :protection, :except => :json_csrf # 使前端ajax可以跨域访问

  before do
    # read post requests parmas to hash
    response['Access-Control-Allow-Origin'] = '*' 

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
end


Dir['./helpers/*.rb'].each { |file| require_relative file }

ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    database: './my_blog_development.sqlite2',
    reaping_frequency: 4,
    pool:     6   
)

# 导入所有 api routes 这是使用打开类添加路由
Dir['./api_routes/*.rb'].each { |file| require_relative file }

# require models
Dir['./models/*.rb'].each { |file| require_relative file }


# p ActiveRecord::Base.connection.tables
# modular the Sinatra app
# can run it in config.ru





