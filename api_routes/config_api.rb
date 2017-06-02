class MyApp < Sinatra::Application
  post '/get_config' do
    url_prefix = Settings.UPyun.url_prefix
    begin
      {data: {UPyun: {url_prefix: url_prefix}}}.suc_json
    rescue Exception => e
      {msg: e.to_s}.fail_json
    end
  end 
end