# 本文件
# 1. 引入 active_record
# 2. 引入 model
# 3. 连接测试数据库并自动删除测试中产生的数据

require_relative './test_basic'

require 'active_record'
require 'database_cleaner'

ActiveRecord::Base.establish_connection(
    adapter:           "sqlite3",
    database:          "./db/my_blog_#{ENV['RACK_ENV']}.sqlite3",
    reaping_frequency: 4,
    pool:              6   
)

DatabaseCleaner.strategy = :transaction

Dir['./models/*.rb'].each { |file| require file }

class TestDbConn < TestBasic
  def setup
    super
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end