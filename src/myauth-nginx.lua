-- myauth-jwt-nginx.lua
-- nginx wrapper

local _M = {}

_M.debug_mode = false

function _M.set_debug_authorization_header(info)
  if _M.debug_mode then
    ngx.header["X-Authorization-Debug"] = info
  end
end

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

  if _M.debug_mode and msg ~=nil then
    ngx.req.set_header("Content-Type", "text/plain") 
    ngx.print(msg)
  end

  ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

function _M.exit_forbidden(msg)
  set_source_header()
  
  if _M.debug_mode and msg ~=nil then
    ngx.req.set_header("Content-Type", "text/plain") 
    ngx.print(msg)
  end

  ngx.exit(ngx.HTTP_FORBIDDEN)
end

function _M.exit_internal_error(code)
  set_source_header()
  ngx.req.set_header("Content-Type", "text/plain") 
  ngx.print("error_code: " .. code)
  ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR )
end

return _M