-- myauth-jwt-test-nginx.lua
-- nginx wrapper for tests

local _M = {}

local _set_source_header = function()
  
end

function _M.exit_unauthorized(self, msg)
  error("Set UNAUTHORIZED: " .. msg);
end

function _M.exit_forbidden(self, msg)
  error("Set FORBIDDEN: " .. msg);
end

return _M;