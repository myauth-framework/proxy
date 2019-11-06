-- myauth-jwt-nginx.lua
-- nginx wrapper

local cjson = require "cjson"

local _M = {}

local function set_source_header()
  --ngx.req.set_header("X-Response-Source", "myauth-proxy")
  ngx.header["X-Response-Source"] = "myauth-proxy"
end

function _M.set_user_id(userId)
	ngx.req.set_header("X-User-Id", userId)
end

function _M.set_user_claims(claims)
	ngx.req.set_header("X-User-Claims", claims)
end

function _M.exit_unauthorized(msg)
  set_source_header()
  ngx.status = ngx.HTTP_UNAUTHORIZED
  ngx.print(msg)
  ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

function _M.exit_forbidden(msg)
  set_source_header()
  ngx.status = ngx.HTTP_FORBIDDEN
  ngx.print(msg)
  ngx.exit(ngx.HTTP_FORBIDDEN)
end

return _M