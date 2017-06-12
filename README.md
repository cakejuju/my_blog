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

#### nginx config

```
server {
    listen       80;
    server_name  xx.xx.xx.xx;

    charset utf-8;

    access_log  access.log  main;

    location /api/ {
       proxy_pass  http://127.0.0.1:9292/; # 与后端项目启动端口保持一致
       add_header 'Access-Control-Allow-Origin' '*';
       add_header 'Access-Control-Allow-Credentials' 'true';
       add_header 'Access-Control-Allow-Methods' 'GET';
       add_header 'Access-Control-Allow-Methods' 'POST';
    }

    location / {
       root /....; # vue 项目 build 后的目录位置 
       index index.html;
       try_files $uri $uri/ @router; # 应对 vue-router 单页刷新 404

    }


    location @router {
        rewrite ^.*$ /index.html last;
    }
}
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


