class MyApp < Sinatra::Application
  post '/get_config' do
    api_should do
      url_prefix = Settings.UPyun.url_prefix
      {data: {UPyun: {url_prefix: url_prefix}}}
    end
  end 
end