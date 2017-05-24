require "sinatra/activerecord/rake"

# load your app before execute rake db task
namespace :db do
  task :load_config do
    require "./app"
  end
end

# 重启任务
# 指令: rake restart env=#{env}
task :restart do
  env = ENV['env'] ? ENV['env'] : 'development'
  p ENV
end
