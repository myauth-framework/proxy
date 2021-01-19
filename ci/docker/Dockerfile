FROM openresty/openresty:1.15.8.3-centos

ARG VERSION

RUN echo $VERSION

ADD ./nginx-config.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /app/configs \
 && touch /app/configs/auth-config.lua \
 && touch /app/configs/auth-secrets.lua \
 && mkdir -p /etc/nginx/snippets \
 && touch /etc/nginx/snippets/default-location.conf
RUN yum -y install git gcc
RUN /usr/local/openresty/luajit/bin/luarocks install myauth $VERSION
