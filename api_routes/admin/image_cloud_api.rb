
class MyApp < Sinatra::Application
  get '/admin/image_cloud/file_lists' do
    begin
      file_url = '/production/heads/'
      files = show_image_cloud_file_lists file_url
      {data: files, success: 1}.suc_json
    rescue Exception => e
      {success: 0, msg: e.to_s}.fail_json
    end
  end


  post '/admin/image_cloud/file_lists' do
    begin
      file_url = @params[:file_url]
      files = show_image_cloud_file_lists file_url
      {data: files, success: 1}.suc_json
    rescue Exception => e
      {success: 0, msg: e.to_s}.fail_json
    end
  end

  post '/admin/image_cloud/delete_file' do
    begin
      upyun = init_UPyun

      file_path = @params[:file_path]

      res = upyun.delete(file_path) # true false
      # 删除文件夹时 若其中有内容 则无法删除
      p res
      res == true ? {}.suc_json : {msg: '删除失败'}.fail_json
    rescue Exception => e
      {success: 0, msg: e.to_s}.fail_json
    end
  end

end