class MyApp < Sinatra::Application
  post '/login' do
    username = @params['username'].to_s
    password = @params['password'].to_s

    member = Member.find_by(username: username, password: SHA1(password))

    if member
      jwt = jwt_encode({ member_id: member.id, 
                         is_master: member.is_master,
                         head_img_url: member.head_img_url,
                         username: member.username,
                         nickname: member.nickname})
      data = { nickname: member.nickname, head_img_url: member.head_img_url }
      {success: 1, jwt: jwt, current_member: data}.to_json
    else 
      {success: 0, msg: '账号或密码输错了吧'}.to_json
    end
  end  
end