-- myauth-config.lua
-- v 1.0.0

local _M = {}

function _M.load(filepath)
	local configEnv = {}

	local f,err = loadfile(filepath, "t", configEnv)

	if f then
	   f()
	   _M.anon = configEnv.anon
	   _M.basic = configEnv.basic
	   _M.rbac = configEnv.rbac
	   _M.white_list = configEnv.white_list
	else
	   error(err)
	end
end

return _M