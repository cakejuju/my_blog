class MyApp < Sinatra::Application

  post '/login' do
    params = JSON.parse(request.body.read)
    p params
    username = params['username'].to_s
    password = params['password'].to_s
    # params.merge!({model: 'Post', json_methods:['written_time', 'tag_names', 'l_content']})
    p username
    p password
    p Member.find_by(username: username)
    member = Member.find_by(username: username, password: SHA1(password))

    content_type :json

    if member
      jwt = jwt_encode({member_id: member.id, is_master: member.is_master})

      {success: 1, jwt: jwt}.to_json
    else 
      {success: 0, msg: '不存在的'}.to_json
    end
    
  end  

end