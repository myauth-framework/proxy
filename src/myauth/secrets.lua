-- myauth.secrets

local _M = {}

function _M.load(filepath)
	local configEnv = {}

	local f,err = loadfile(filepath, "t", configEnv)

	if f then
	   f()
	   _M.jwt_secret = configEnv.jwt_secret
	else
	   error(err)
	end
end

return _M