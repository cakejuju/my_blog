class ActiveRecord::Base
  def second_time_to_text(origin_seconds)
    # origin_seconds = (object.finished_at - object.created_at).round(2)
    time = origin_seconds.to_i

    hs = time / 3600
    if hs >= 24
      period = "#{hs}:#{hs/60}:00"
    else
      period = Time.at(time).utc.strftime("%H:%M:%S")
    end

    arr =  period.split(":")
    seconds = arr[2].to_i
    minutes = arr[1].to_i
    hours = arr[0].to_i

    if hours > 0
      time = hours.to_s + "小时" + minutes.to_s + "分"
    elsif hours == 0 && minutes > 0
      time = minutes.to_s + "分" + seconds.to_s + "秒"
    elsif minutes == 0  && seconds > 0
      time = origin_seconds.to_s + "秒"
    end    
  end
end