class MyApp < Sinatra::Application

  post '/get_photographs' do
    api_should do
      @params.merge!({model: 'Photograph'})

      model_data = model_get_data(@params)

      # relation_data = model_data[:relation_data]

      # json_data = relation_data.as_json(methods:['exif_v'],
      #                                   only: @params[:json_only])

      # model_data.merge!(json_data: json_data)
    end
  end
end  