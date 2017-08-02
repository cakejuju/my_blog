class ActiveRecord::Base
  def second_time_to_text(origin_seconds)
    time = origin_seconds.to_i

    raise ArgumentError.new("必须是过去的时间") if time < 0

    if time.between?(0,60)
      '刚刚'
    elsif time.between?(61,3600)
      "#{time/60}分钟前"
    elsif time.between?(3601,86400)
     "#{time/3600}小时前"
    elsif time.between?(86401,604800)
     "#{time/86400}天前"  
    elsif time.between?(604801,2419200)
      "#{time/604800}周前"  
    elsif time.between?(2419201,29030400)
      "#{time/2419200}月前"    
    else 
      "#{time/29030400}年前"     
    end
  end
end