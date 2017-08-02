require_relative '../test_db_conn' 
# 要测试的文件
require 'sinatra/base'
require "sinatra/cookies"
require "sinatra/activerecord"

class MyApp < Sinatra::Application
  set :protection, :except => :json_csrf # 使前端ajax可以跨域访问 开发使用,在生产环境用nginx做代理
  configure do
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

require_relative '../../helpers/api_helper'

class ApiHelperTest < TestDbConn

  # def api_should(&block)
  #   begin
  #     block.call.suc_json
  #   rescue Exception => e
  #     {success: 0, msg: e.to_s}.fail_json
  #   end
  # end

  def test_api_should
    # assert mocked_obj.method(:api_should).arity == -1 # 方法接收 1 个参数
  end

  def mocked_obj
  end
end

