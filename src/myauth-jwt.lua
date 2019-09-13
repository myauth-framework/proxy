-- myauth-jwt.lua

local _M = {}

require "myauth-jwt-nginx"

_M.strategy = NgnxStrategy:new()

function _M.authorize()
  
  local auth_header = ngx.var.http_Authorization
  
  authorize_header(auth_header);
  
end

function _M.authorize_header(auth_header)
  
  if auth_header == nil then
    strategy.exit_unauthorized("Missing token header")
  end

  local _, _, token = string.find(auth_header, "Bearer%s+(.+)")
  if token == nil then
    strategy.exit_unauthorized("Missing token")
  end

  local jwt = require "resty.jwt"
  local jwt_obj = jwt:load_jwt('', token)

  if not jwt_obj.valid then
    strategy.exit_unauthorized("Invalid token")
  end
  
  local sub = jwt_obj.payload['sub']
  if sub == nil then
    strategy.exit_unauthorized("Invalid token")
  end
  
end

--function _M.authorize_only_roles(...)
--      for i,v in ipairs(arg) do
 --       printResult = printResult .. tostring(v) .. "\t"
--      end
--      printResult = printResult .. "\n"
--end

return _M