class MyApp < Sinatra::Application

  post '/upload/head_img' do 
    begin
      p @params

      upyun = Upyun::Form.new("ZvmSM4XlWxmvJ6th7K9HR2BjXH0=", 'blog-src', {})

      opts = {
        'save-key' => '/test/images/learning.png',
        'content-type' => 'image/jpeg',
        'image-width-range' => '0,22024',
        'return-url' => 'http://www.example.com'
      }

      tempfile = @params['file']['tempfile']
      p tempfile.path
      # tempfile.unlink    # deletes the temp file
      # res = upyun.upload(tempfile.path, opts)
      # p res
      {file_path: tempfile.path}.suc_json
    rescue Exception => e
      {msg: e.to_s}.fail_json
    end

  end


  post '/pic' do 
    tempfile = params['file']['tempfile']
    p tempfile.path

    return {success: 1, file_path: tempfile.path}.to_json
  end

  # form 提交图片时得有 options 路由
  options '/upload/head_img' do 
  end


end
