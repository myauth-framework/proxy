-- myauth.lua
-- v 1.0.0

local _M = {}

_M.config = nil;
_M.strategy = require "myauth-nginx"

local base64 = require "libs.base64"
local cjson = require "libs.json"
local mjwt = require "myauth-jwt"

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function get_basic_user(value)

  local decoded = base64.decode(value)
  local sep_index = decoded:find(":")
  return decoded:sub(1, sep_index-1)

end

local function check_anon(url)
  
  if(_M.config == nil or _M.config.anon == nil) then
    _M.strategy.exit_forbidden("Access denied")
  end
  
  for i, url_pattern in ipairs(_M.config.anon) do
    if(string.match(url, url_pattern)) then
      return
    end
  end

  _M.strategy.exit_forbidden("Access denied")
end

local function check_basic(url, cred)

  if(_M.config == null or _M.config.basic == nil) then
    _M.strategy.exit_forbidden("There's no basic access")
  end

  local user_id = get_basic_user(cred)

  for i, item in ipairs(_M.config.basic) do
    if(string.match(url, item.url) and has_value(item.users, user_id)) then
      _M.strategy.set_user_id(user_id)
      return
    end
  end

  _M.strategy.exit_forbidden("Access denied")
end

local function check_rbac(url, token, host)

  if(_M.config == null or _M.config.rbac == nil or _M.config.rbac.rules == nil) then
    _M.strategy.exit_forbidden("There's no bearer access")
  end

  mjwt.secret = _M.config.rbac.secret
  mjwt.strategy = _M.strategy

  for i, item in ipairs(_M.config.rbac.rules) do
    if(string.match(url, item.url)) then
      mjwt.authorize_roles(token, host, item.roles)
      return
    end
  end

  _M.strategy.exit_forbidden("Access denied")
end

function _M.authorize()

  local auth_header = ngx.var.http_Authorization
	local host_header = ngx.var.http_Host
  local url = ngx.var.request_uri
  
  _M.authorize_core(url, auth_header, host_header)
end

function _M.authorize_core(url, auth_header, host_header)

  if(_M.config == nil) then
    error("MyAuth config was not loaded")
  end

  if auth_header == nil then
    check_anon(url)
    return
	end

	local _, _, token = string.find(auth_header, "Bearer%s+(.+)")
	if token ~= nil then
  	check_rbac(url, token, host_header)
  	return
	end

	local _, _, basic = string.find(auth_header, "Basic%s+(.+)")
	if basic ~= nil then
  	check_basic(url, basic)
  	return
	end

  _M.strategy.exit_forbidden("Unsupported authorization type")
end

return _M;