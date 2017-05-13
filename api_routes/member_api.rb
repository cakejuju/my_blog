class MyApp < Sinatra::Application

  post '/member/currentMember' do 
    begin
      member = current_member
      if member

        data = { nickname: member.nickname, head_img_url: member.head_img_url }
        {success: 1, current_member: data}.to_json 
      else 
        {success: 0, msg: '尚未登录'}.to_json   
      end

    rescue Exception => e
      {success: 0, msg: e.to_s}.to_json 
    end 
  end


end
