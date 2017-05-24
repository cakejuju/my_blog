class MyApp < Sinatra::Application

  post '/upload/head_img' do 
    begin
      tempfile = @params['file']['tempfile']
      
      {file_path: tempfile.path}.suc_json
    rescue Exception => e
      {msg: e.to_s}.fail_json
    end
  end

  # form 提交图片时得有 options 路由
  options '/upload/head_img' do 
  end


end
