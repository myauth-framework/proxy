FROM openresty/openresty:1.15.8.3-centos

ARG MYAUTH_LUA_VERSION

RUN echo $MYAUTH_LUA_VERSION

ADD ./out/nginx-config.conf /etc/nginx/conf.d/default.conf 
ADD ./out/main.conf /usr/local/openresty/nginx/conf/nginx.conf

RUN mkdir -p /app/configs \
 && touch /app/configs/auth-config.lua \
 && touch /app/configs/auth-secrets.lua \
 && mkdir -p /etc/nginx/snippets \
 && touch /etc/nginx/snippets/default-location.conf \
 && yum -y install git gcc 
RUN /usr/local/openresty/luajit/bin/luarocks install myauth $MYAUTH_LUA_VERSION 
RUN /usr/local/openresty/luajit/bin/luarocks install nginx-lua-prometheus 0.20201218
