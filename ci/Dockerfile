FROM openresty/openresty:1.15.8.3-centos

ADD ./out/app /app/libs
ADD ./nginx-config.conf /etc/nginx/conf.d/default.conf
ADD ./auth-config.lua /app/configs/auth-config.lua

