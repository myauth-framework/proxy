-- myauth-jwt.lua
-- v 1.1.0

local _M = {}

local cjson = require "libs.json"

_M.strategy = require "myauth-nginx"
_M.secret = nil
_M.ignore_audience = false

local function check_and_provide_token_from_header(token, host)
  if token == nil then
    _M.strategy.exit_unauthorized("Missing token")
  end

  local jwt = require "resty.jwt"

  if _M.secret == nil then
    error("Secret not specified")
  end

  local jwt_obj = jwt:verify(_M.secret, token)

  if not jwt_obj.verified then
    _M.strategy.exit_unauthorized("Invalid token: " .. jwt_obj.reason)
  end

  if not _M.ignore_audience then
    if jwt_obj.payload.aud ~= null then
      if host ~= nil then
        if(jwt_obj.payload.aud ~= host) then
            _M.strategy.exit_unauthorized("Invalid audience. Expected '" .. jwt_obj.payload.aud .. "' but got '" .. host .. "'")
        end
      else
        _M.strategy.exit_unauthorized("Cant detect a host to check audience")
      end
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

local function set_user_headers(jwt_payload)
  _M.strategy.set_user_id(jwt_payload.sub)

  local claims = {}
  for k,v in pairs(jwt_payload) do
    if k ~= "iss" and 
       k ~= "sub" and 
       k ~= "aud" and 
       k ~= "exp" and 
       k ~= "nbf" and 
       k ~= "iat" and 
       k ~= "jti" then
      claims[k] = v
    end
  end

  _M.strategy.set_user_claims(cjson.encode(claims))
end

-- Check JWT token from current 'Authorization' header with specified roles
function _M.authorize_roles(token, host, target_roles)

    local jwt_obj = check_and_provide_token_from_header(token, host)

    local role = jwt_obj.payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']

    --print(cjson.encode(jwt_obj.payload.roles))

    if role ~= nil then
      
      if has_value(target_roles, role) then
        set_user_headers(jwt_obj.payload)
        return true
      end
    
    elseif jwt_obj.payload.roles ~= nil then

      for key,value in ipairs(jwt_obj.payload.roles) 
      do
        if has_value(target_roles, value) then
          set_user_headers(jwt_obj.payload)
          return true
        end
      end

    else

      _M.strategy.exit_forbidden("Roles not specified")  

    end

    _M.strategy.exit_forbidden("Access denied for your role")
end

return _M