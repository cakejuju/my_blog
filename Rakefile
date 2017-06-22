require "sinatra/activerecord/rake"
# require "sinatra/activerecord"



# 重启任务
# 指令: rake restart env=#{env}
task :restart do
  env = ENV['env'] ? ENV['env'] : 'development'
  p ENV
end

# 初始化第三方服务配置
# 指令: rake init_service env=#{env}
# 如: 又拍云账号信息
task :init_service do 
  env = ENV['env'] ? ENV['env'] : 'development'
  file_path = "./config/application_#{env}.yml"

  `cp ./config/application_default.yml #{file_path}` unless File.file?(file_path)
end
