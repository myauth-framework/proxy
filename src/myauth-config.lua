-- myauth-config.lua

local _M = {}

function _M.load(filepath)
	local configEnv = {}

	local f,err = loadfile(filepath, "t", configEnv)

	if f then
	   f()
	   _M.anon = configEnv.anon
	   _M.basic = configEnv.basic
	   _M.rbac = configEnv.rbac
	   _M.only_apply_for = configEnv.only_apply_for
	   _M.dont_apply_for = configEnv.dont_apply_for
	   _M.black_list = configEnv.black_list
	   _M.debug_mode = configEnv.debug_mode

	   if _M.rbac.ignore_audience == nil then
	   	_M.rbac.ignore_audience = false
	   end
	else
	   error(err)
	end
end

return _M