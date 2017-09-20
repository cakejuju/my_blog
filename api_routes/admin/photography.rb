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

      # 访问 url + !detail 地址得到 json 格式的图片详情
      # http://blog-src.b0.upaiyun.com/development/photography/RackMultipart20170919-89728-1ebzb5y.png!detail
      detail = send_get_req(Settings.UPyun.url_prefix, (cloud_save_path + '!detail'))
      # =>
      # {"width":3264,"height":2448,"frames":1,"type":"JPEG","EXIF":{"Make":"Apple","Model":"iPhone 6","Orientation":"1",
      #  "XResolution":"72/1","YResolution":"72/1","ResolutionUnit":"2","Software":"10.3.2",
      #  "DateTime":"2017:09:17 11:13:27","YCbCrPositioning":"1","ExifOffset":"194",
      #  "ExposureTime":"1/100","FNumber":"11/5","ExposureProgram":"2","ISOSpeedRatings":"40",
      #  "ExifVersion":"0221","DateTimeOriginal":"2017:09:17 11:13:27",
      #  "DateTimeDigitized":"2017:09:17 11:13:27","ComponentsConfiguration":"\\001\\002\\003\\000",
      #  "ShutterSpeedValue":"18513/2786","ApertureValue":"7983/3509","BrightnessValue":"7286/1407",
      #  "ExposureBiasValue":"0/1","MeteringMode":"3","Flash":"16","FocalLength":"83/20",
      #  "SubjectArea":"1587","SubSecTimeOriginal":"062","SubSecTimeDigitized":"062","FlashPixVersion":"0100",
      #  "ColorSpace":"1","ExifImageWidth":"3264","ExifImageLength":"2448","SensingMethod":"2",
      #  "SceneType":"\\001","ExposureMode":"0","WhiteBalance":"0","FocalLengthIn35mmFilm":"29",
      #  "SceneCaptureType":"0","0xA432":"83/20","0xA433":"Apple","0xA434":"iPhone 6 back camera 4.15mm f/2.2"}}
      photograph = Photograph.create!(img_url: img_url,
                         description: description,
                         exif: detail['EXIF'].to_json)

      {img_url: img_url}
    end
  end
end