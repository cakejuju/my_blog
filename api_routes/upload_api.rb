class MyApp < Sinatra::Application

  post '/upload/head_img' do 
    api_should do
      tempfile = @params['file']['tempfile']
      
      {file_path: tempfile.path} 
    end
  end

  # form 提交图片时得有 options 路由
  options '/upload/head_img' do 
  end

  post '/upload/posts_img' do 
    tempfile_path = @params['file']['tempfile'].path

    cloud_save_path = "/#{ENV['RACK_ENV']}/posts/#{File.basename(tempfile_path)}.png"
        
    res = up_upload(tempfile_path, cloud_save_path)
    # {:"image-type"=>"PNG", :"image-frames"=>1, :"image-height"=>665, 
    # :sign=>"5ecd230e4c746c66b4f17607e905b85f", :code=>200, :file_size=>62023, 
    # :"image-width"=>800, :url=>"/production/posts/RackMultipart20170601-70335-phafu7.png", 
    # :time=>1496287066, :message=>"ok", :mimetype=>"image/png", 
    # :request_id=>"09fa82255d7f12add8c3fc28d4fdac6f"}
    res[:code] == 200 ? res.merge!({file_path: "#{Settings.UPyun.url_prefix+res[:url]}"} ).suc_json : res.fail_json  
  end

  options '/upload/posts_img' do 
  end

end
