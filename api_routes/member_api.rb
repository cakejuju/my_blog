class MyApp < Sinatra::Application
  # 获取当前登录 member
  post '/member/currentMember' do 
    begin
      member = current_member
      if member
        data = { nickname: member.nickname, head_img_url: member.head_img_url, email: member.email }

        {current_member: data}.suc_json
      else 
        {msg: '尚未登录'}.fail_json
      end
    rescue Exception => e
      {msg: e.to_s}.fail_json
    end 
  end


  post '/member/register' do 
    begin
      p @params
      email = @params[:email]
      nickname = @params[:nickname]
      tempfile_path = @params[:tempfile_path]
      # "/var/folders/_0/5sck246s4_b7thqzqr6pqv6r0000gn/T/RackMultipart20170523-6351-1dvk20.jpeg"
      return {msg: '参数不足'}.fail_json unless email.present? && nickname.present?

      return {msg: '对应邮箱的用户已经存在了'}.fail_json if memberExsit?

      # tempfile_path 不存在的情况下读取默认图片党头像
      # 存在则上传至又拍云得到回调地址
      if tempfile_path.present?
        # comments articles heads
        cloud_save_path = "/production/heads/#{File.basename(tempfile_path)}"
        p cloud_save_path

        res = up_upload(tempfile_path, cloud_save_path)
        p res
        # => {:sign=>"229ddc675e70d734c703502b1c12668e", :code=>200, :file_size=>5239, :url=>"/2017/05/18/yace_jiami.rb", :time=>1495099874, :message=>"ok", :mimetype=>"text/plain; charset=utf-8", :request_id=>"15f8307656c8a18741dcdc9925c3cde2"}
        return {msg: "图片上传失败了: #{res[:message]}"}.fail_json unless res[:code] == 200

        head_img_url = "http://blog-src.b0.upaiyun.com#{res[:url]}"
      else 
        head_img_url = "/static/github.png" 
      end

      member = Member.create!(nickname: nickname, email: email, head_img_url: head_img_url, is_master: false)

      login_member_info(member)
      # {current_member: data}.suc_json
      # tempfile.unlink    # deletes the temp file
    rescue Exception => e
      {msg: e.to_s}.fail_json
    end
  end

  private
  def memberExsit?
    Member.find_by(email: self.params[:email]) ? true : false
  end




end
