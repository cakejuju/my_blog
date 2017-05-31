class MyApp < Sinatra::Application
  post '/login' do
    email = @params['email'].to_s

    member = Member.find_by(email: email)

    if member
      login_member_info(member)
    else 
      {success: 0, msg: '好像还没这个账号'}.to_json
    end
  end 


end