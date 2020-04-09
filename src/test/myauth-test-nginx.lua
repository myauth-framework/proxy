-- myauth-jwt-test-nginx.lua
-- nginx wrapper for tests

local _M = {}

_M.debug_info = "nil"

function _M.set_debug_authorization_header(info)
  _M.debug_info = info
end

function _M.set_source_header()
  -- print("Set X-Response-Source header: myauth-proxy")
end

function _M.set_user_id(user_id)
	--print("Set X-User-Id header: " .. user_id)
end

function _M.set_user_claims(claims)
	--print("Set X-User-Claims header: " .. claims)
end

function _M.exit_unauthorized(msg)
  	error("Set UNAUTHORIZED: " .. msg);
end

function _M.exit_forbidden(msg)
	if msg ~=nil then
  		error("Set FORBIDDEN: " .. msg);
  	else
  		error("Set FORBIDDEN: Access denied");
  	end
end

function _M.exit_internal_error(code)
  	error("Set HTTP_INTERNAL_SERVER_ERROR: " .. code);
end

return _M;