require 'sinatra/base'
require "sinatra/cookies"
require 'active_record'
require "sinatra/activerecord"
require "sqlite3"
require 'jwt' # json web token
require 'redcarpet'
require 'upyun' # 又拍云 SDK

# require 'sinatra'

# 使用sqlite3 创建数据库 => ./bin/rake db:create RACK_ENV=#{RACK_ENV}

# run sinatra console by => $ irb -r ./app.rb
# production console => $ RACK_ENV=production irb -r ./app.rb
# modular the Sinatra app
# can run it in config.ru

# class Timing
#   def initialize(app)
#     @app = app
#   end

#   def call(env)
#     p env
#     ts = Time.now
#     status, headers, body = @app.call(env)
#     elapsed_time = Time.now - ts
#     puts "Timing: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']} #{elapsed_time.round(3)}"
#     return [status, headers, body]
#   end
# end

Dir['./helpers/*.rb'].each { |file| require_relative file }
class MyApp < Sinatra::Application
  include ApiHelper
  # use Timing
  set :protection, :except => :json_csrf # 使前端ajax可以跨域访问 开发使用,在生产环境用nginx做代理
  configure do
    # logging is enabled by default in classic style applications,
    # so `enable :logging` is not needed
    # p settings.path
    file = File.new("#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file # Rack 中间件记录日志
  end

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



# env = ENV['RACK_ENV'] ? ENV['RACK_ENV'] : 'development'
env = ENV['RACK_ENV'] || 'development'

# TODO 数据库配置从 config/database.yml 读取
ActiveRecord::Base.establish_connection(
    adapter:           "sqlite3",
    database:          "./db/my_blog_#{env}.sqlite3",
    reaping_frequency: 4,
    pool:              6   
)

# 导入所有 api routes 这是使用打开类添加路由
%w[./api_routes/*.rb  ./api_routes/admin/*.rb  ./models/*.rb].each do |path|
  Dir[path].each { |file| require_relative file }
end

# Dir['./api_routes/*.rb'].each { |file| require_relative file }
# Dir['./api_routes/admin/*.rb'].each { |file| require_relative file }
# require models
# Dir['./models/*.rb'].each { |file| require_relative file }








