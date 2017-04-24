require 'sinatra/base'
require 'active_record'
require "sinatra/activerecord"
require "sqlite3"

# p Gem.loaded_specs.values.map {|x| "#{x.name} #{x.version}"}
# p ENV

# set :database, {adapter: "sqlite3", database: "my_blog_#{ENV['env']}.sqlite3"}

# 使用sqlite3 创建数据库 => sqlite3 DatabaseName.db
# run sinatra console by => $ irb -r ./app.rb
ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    database: './my_blog_development.sqlite2',
    reaping_frequency: 4
    # pool:     20   # 在连接数据库的定时任务很多时，会出现could not connect to database的问题。
                     # 将该参数增加，但不宜过大，以免造成too many clients的问题。
)


# p ActiveRecord::Base.connection.tables
# modular the Sinatra app
# can run it in config.ru
class MyApp < Sinatra::Application
  set :protection, :except => :json_csrf # 使前端ajax可以跨域访问

  get '/' do
    send_file './views/index.html'
  end

  get '/get_some_data' do
    content_type :json
    {hi: 'this is your data'}.to_json
    # "dsdssdds"
  end

  get '/hello/:name' do |n|
    # 匹配"GET /hello/foo" 和 "GET /hello/bar"
    # params[:name] 的值是 'foo' 或者 'bar'
    # n 中存储了 params['name']
    "Hello #{n}! and #{params['name']}"
  end
end


