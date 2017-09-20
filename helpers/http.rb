module HttpSender
  require 'typhoeus/adapters/faraday'

  # 连接
  def connection(timeout = 60, open_timeout = 60)
    @connection ||= Faraday.new( ssl: { verify: false } ) do |conn|
      conn.request  :multipart
      conn.request  :url_encoded
      conn.request  :retry, max: 0, interval: 0.05,
                    interval_randomness: 0.5, backoff_factor: 2,
                    exceptions: [Faraday::TimeoutError, Timeout::Error]
      conn.response :logger
      conn.adapter  :typhoeus
      conn.options.timeout = timeout
      conn.options.open_timeout = open_timeout
    end
  end


  def send_get_req(url, path, timeout = 60, open_timeout = 60, res_format = 'json')
    @connection ||= connection(timeout, open_timeout)

    begin
      res = @connection.get do |req|
         req.url (url + path)
         req.options.timeout = timeout
         req.options.open_timeout = open_timeout
      end

      if res_format == 'json'
        JSON.parse(res.body)
      elsif res_format == 'xml'
        Helper.xml_str_to_hash(res.body)   
      else
        res.body
      end
    rescue Exception => exception
       { message: exception.message }
    end
  end  

end