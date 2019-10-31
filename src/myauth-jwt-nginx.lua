-- myauth-jwt-nginx.lua
-- nginx wrapper

local _M = {}

local _set_source_header = function()
  ngx.req.set_header("X-ResponseSource", "myauth-proxy")
end

function _M.exit_unauthorized(msg)
  _set_source_header()
  ngx.status = ngx.HTTP_UNAUTHORIZED
  ngx.say(msg)
  ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

function _M.exit_forbidden(msg)
  _set_source_header()
  ngx.status = ngx.HTTP_FORBIDDEN
  ngx.say(msg)
  ngx.exit(ngx.HTTP_FORBIDDEN)
end

return _M