-- myauth-jwt-nginx.lua
-- nginx wrapper

local _M = {}

_M.debug_mode = false

function _M.set_debug_authorization_header(info)
  if _M.debug_mode then
    ngx.header["X-Authorization-Debug"] = info
  end
end

function _M.set_auth_header(claims)
  ngx.req.set_header("Authorization", "MyAuth1 " .. claims)
end

function _M.exit_unauthorized(msg)
  ngx.status = ngx.HTTP_UNAUTHORIZED
  if _M.debug_mode and msg ~=nil then
    ngx.req.set_header("Content-Type", "text/plain") 
    ngx.print(msg)
  end
  ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

function _M.exit_forbidden(msg)  
  ngx.status = ngx.HTTP_FORBIDDEN
  if _M.debug_mode and msg ~=nil then
    ngx.req.set_header("Content-Type", "text/plain") 
    ngx.print(msg)
  end
  ngx.exit(ngx.HTTP_FORBIDDEN)
end

function _M.exit_internal_error(code)
  
  ngx.req.set_header("Content-Type", "text/plain") 
  ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
  ngx.print("error_code: " .. code)
  ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

return _M