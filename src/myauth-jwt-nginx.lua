-- myauth-jwt-nginx.lua

require "class"

NginxStrategy = class()

local _set_source_header = function()
  ngx.req.set_header("X-ResponseSource", "myauth-proxy")
end

function NginxStrategy:exit_unauthorized(msg)
  _set_source_header()
  ngx.status = ngx.HTTP_UNAUTHORIZED
  ngx.say(msg)
  ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
