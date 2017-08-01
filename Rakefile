require "sinatra/activerecord/rake"
require "sinatra/activerecord"
require "rake/testtask"

# 测试任务
# 指令: rake run_test
# Rake::TestTask.new(:run_test) do |t|
#   t.libs << "test"
#   t.libs << "lib"
#   t.test_files = FileList['test/**/*_test.rb']
#   t.warning = false
# end

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


# 这里增加测试任务

Rake::TestTask.new(:test) do |t|
  puts "TODO: test will be add"
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = false
end

task :default => :test