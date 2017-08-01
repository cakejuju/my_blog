class ActiveRecord::Base
  def second_time_to_text(origin_seconds)
    time = origin_seconds.to_i

    if time < 60
      '刚刚'
    elsif time >= 60 && time < 3600
      "#{time/60}分钟前"
    elsif time >= 3600 && time < 86400     
     "#{time/3600}小时前"
    elsif time >= 86400 && time < 604800 
     "#{time/86400}天前"  
    elsif time >= 604800 && time < 2419200 
      "#{time/604800}周前"  
    elsif time >= 2419200 && time < 29030400 
      "#{time/2419200}月前"    
    end
  end
end