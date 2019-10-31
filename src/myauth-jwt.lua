-- myauth-jwt.lua
-- v 1.0.0

local _M = {}

require "myauth-jwt-nginx"
local cjson = require "cjson"

_M.strategy = require "myauth-jwt-nginx"
_M.secret = nil

local function check_and_provide_token_from_header(auth_header, host_header)
  if auth_header == nil then
    _M.strategy:exit_unauthorized("Missing token header")
  end

  local _, _, token = string.find(auth_header, "Bearer%s+(.+)")
  if token == nil then
    _M.strategy:exit_unauthorized("Missing token")
  end

  local jwt = require "resty.jwt"

  if _M.secret == nil then
    error("Secret not specified")
  end

  local jwt_obj = jwt:verify(_M.secret, token)

  if not jwt_obj.verified then
    _M.strategy:exit_unauthorized("Invalid token: " .. jwt_obj.reason)
  end

  local _, _, host = string.find(host_header, "Host:%s+(.+)")
  if jwt_obj.payload.aud ~= null then
    if host ~= nil then
      if(jwt_obj.payload.aud ~= host) then
          _M.strategy:exit_unauthorized("Invalid audience. Expected '" .. jwt_obj.payload.aud .. "' but got '" .. host .. "'")
      end
    else
      _M.strategy:exit_unauthorized("Cant detect a host to check audience")
    end
  end 
  
  return jwt_obj
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

-- Check JWT token from current 'Authorization' header without roles and climes
function _M.authorize()
  
  local auth_header = ngx.var.http_Authorization
  local host_header = ngx.var.http_Host
  authorize_header(auth_header, host_header)
  
end

-- Check JWT token from specified header without roles and climes
function _M.authorize_header(auth_header, host_header)
  check_and_provide_token_from_header(auth_header, host_header)
end

-- Check JWT token from current 'Authorization' header with specified roles
function _M.authorize_for_roles(...)

  local auth_header = ngx.var.http_Authorization
  local host_header = ngx.var.http_Host
  check_and_provide_token_from_header(auth_header, host_header, unpack(arg))

end

-- Check JWT token from current 'Authorization' header with specified roles
function _M.authorize_header_for_roles(auth_header, host_header, ...)

    local jwt_obj = check_and_provide_token_from_header(auth_header, host_header)

    local role = jwt_obj.payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']

    if role == nil then
      _M.strategy:exit_forbidden("Roles not specified")
    end

    local target_roles = table.pack(...)
    if has_value(target_roles, role) then
        return true
      end  

    _M.strategy:exit_forbidden("Access denied")
end

return _M