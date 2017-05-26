# TEC

* Sinatra
* Activerecord
* sqlite3

# Purpose

Server Side without any html. Only providing json api for my blog.



# deploy

### development

```bash
$ bundle install --binstubs
# 数据库
$ ./bin/rake db:create 
$ ./bin/rake db:migarte
$ ./bin/rake db:seed
# 其他配置
$ ./bin/rake init_service 
```

### production

```bash
$ bundle install --binstubs

$ ./bin/rake db:create RACK_ENV=production
$ ./bin/rake db:migrate RACK_ENV=production

$ ./bin/rake init_service env=production
```


# 启动

### development

```bash
$ rerun ./bin/puma # rerun 热重启
```

### production

```bash
$ nohup ./bin/puma -e production &
```


