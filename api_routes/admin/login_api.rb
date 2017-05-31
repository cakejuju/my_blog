class MyApp < Sinatra::Application
  
  # admin 路由的 filter, 验证登录与权限
  before '/admin/*' do
    if request.env["REQUEST_URI"] != "/admin/login"
      @member = current_member

      if @member == false
        halt 403, "咖喱boomboom"
      end

      if @member.is_master == false ||  @member.is_master.nil?
        halt 403, "咖喱boomboom"
      end

    end
  end

  post '/admin/login' do
    username = @params['username'].to_s
    password = @params['password'].to_s

    member = Member.find_by(username: username, password: SHA1(password))

    if member
      login_member_info(member)
    else 
      {success: 0, msg: '账号或密码输错了吧'}.to_json
    end
  end
end