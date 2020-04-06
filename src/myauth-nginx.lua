-- myauth-jwt-nginx.lua
-- nginx wrapper

local _M = {}

local function set_source_header()
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
  ngx.req.set_header("Content-Type", "text/plain") 
  ngx.print(msg)
  ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

function _M.exit_forbidden(msg)
  set_source_header()
  ngx.status = ngx.HTTP_FORBIDDEN
  ngx.req.set_header("Content-Type", "text/plain") 
  if msg ~=1 then
    ngx.print(msg)
  else
    ngx.print("Access denied")
  end
  ngx.exit(ngx.HTTP_FORBIDDEN)
end

function _M.exit_internal_error(code)
  set_source_header()
  ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
  ngx.req.set_header("Content-Type", "text/plain") 
  ngx.print("error_code: " .. code)
  ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR )
end

return _M