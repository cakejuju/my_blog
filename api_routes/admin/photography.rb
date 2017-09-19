class MyApp < Sinatra::Application
  post '/admin/photography/create' do 
    api_should do
      tempfile_path = @params[:tempfile_path]
      description = @params[:description]

      return {msg: "图呢?"}.fail_json unless tempfile_path.present?

      cloud_save_path = "/#{ENV['RACK_ENV']}/photography/#{File.basename(tempfile_path)}"

      res = up_upload(tempfile_path, cloud_save_path)
      # => {:sign=>"229ddc675e70d734c703502b1c12668e", :code=>200, :file_size=>5239, 
      # :url=>"/2017/05/18/yace_jiami.rb", :time=>1495099874, :message=>"ok", 
      # :mimetype=>"text/plain; charset=utf-8", :request_id=>"15f8307656c8a18741dcdc9925c3cde2"}
      return {msg: "图片上传失败了: #{res[:message]}"}.fail_json unless res[:code] == 200

      img_url = get_img_url_from_cloud_callback(res)
      # TODO 创建 photography 对象
      {img_url: img_url}
    end
  end
end