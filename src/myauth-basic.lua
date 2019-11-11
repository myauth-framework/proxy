-- myauth-basic.lua
-- v 1.0.0

local _M = {}

_M.strategy = require "myauth-nginx"

local function check_and_provide_token_from_header(auth_header)
  if auth_header == nil then
    _M.strategy.exit_unauthorized("Missing Authorization header")
  end

  local _, _, token = string.find(auth_header, "Basic%s+(.+)")
  if token == nil then
    _M.strategy.exit_unauthorized("Missing basic auth credentials")
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
    local _, _, host = string.find(host_header, "Host:%s+(.+)")
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

function _M.authorize_header(auth_header)
  local jwt_obj = check_and_provide_token_from_header(auth_header)
  
  set_user_headers(jwt_obj.payload)
end

function _M.authorize()
  
  local auth_header = ngx.var.http_Authorization
  _M.authorize_header(auth_header, host_header)
end

