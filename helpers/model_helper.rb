class ActiveRecord::Base
  def second_time_to_text(origin_seconds)
    time = origin_seconds.to_i

    if time < 60
      '刚刚'
    elsif time >= 60 && time < 3600
      "#{time/60}分钟"
    elsif time >= 3600 && time < 86400     
     "#{time/3600}小时"
    elsif time >= 86400 && time < 604800 
     "#{time/86400}天"  
    elsif time >= 604800 && time < 2419200 
      "#{time/604800}周"  
    elsif time >= 2419200 && time < 29030400 
      "#{time/2419200}月"    
    end
  end
end