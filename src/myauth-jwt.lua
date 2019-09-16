-- myauth-jwt.lua

local _M = {}

require "myauth-jwt-nginx"
local cjson = require "cjson"

_M.strategy = require "myauth-jwt-nginx"
_M.secret = nil

local function check_and_provide_token_from_header(auth_header)
  if auth_header == nil then
    _M.strategy:exit_unauthorized("Missing token header")
  end

  local _, _, token = string.find(auth_header, "Bearer%s+(.+)")
  if token == nil then
    _M.strategy:exit_unauthorized("Missing token")
  end

  local jwt = require "resty.jwt"
  -- local jwt_obj = jwt:load_jwt('', token)

  if _M.secret == nil then
    error("Secret not specified")
  end

  local jwt_obj = jwt:verify(_M.secret, token);

  -- print("Token: " .. token)
  --print(cjson.encode(jwt_obj))

  if not jwt_obj.verified then
    _M.strategy:exit_unauthorized("Invalid token: " .. jwt_obj.reason)
  end

  -- if not jwt:verify_jwt_obj(_M.secret, jwt_obj, "sub") then
  --  _M.strategy:exit_unauthorized("Invalid token")
  -- end
  
  

  --local sub = jwt_obj.payload['sub']
  --if sub == nil then
  --  _M.strategy:exit_unauthorized("Invalid token")
  --end



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
  authorize_header(auth_header);
  
end

-- Check JWT token from specified header without roles and climes
function _M.authorize_header(auth_header)
  check_and_provide_token_from_header(auth_header)
end

-- Check JWT token from current 'Authorization' header with specified roles
function _M.authorize_for_roles(...)

  local auth_header = ngx.var.http_Authorization
  check_and_provide_token_from_header(auth_header, unpack(arg));

end

-- Check JWT token from current 'Authorization' header with specified roles
function _M.authorize_header_for_roles(auth_header, ...)

    local jwt_obj = check_and_provide_token_from_header(auth_header)

    local roles = jwt_obj.payload['myauth:roles']

    if roles == nil then
      _M.strategy:exit_forbidden("Roles not specified")
    end

    local target_roles = table.pack(...)
    for i=1,target_roles.n do
        if has_value(roles, target_roles[i]) then
          return true
        end  
    end

    _M.strategy:exit_forbidden("Access denied")
end

return _M