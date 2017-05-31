
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
      p @params
      file_url = @params[:file_url]
      files = show_image_cloud_file_lists file_url
      {data: files, success: 1}.suc_json
    rescue Exception => e
      {success: 0, msg: e.to_s}.fail_json
    end
  end

end