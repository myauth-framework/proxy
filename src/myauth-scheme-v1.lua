-- myauth-scheme-v1.lua

local claimstr = require "myauth-claim-str"

local _M = {}

function _M.apply_rbac(claims, nginx)
	local claims_str = claimstr.from_claims(claims)
  	nginx.set_auth_header("MyAuth1" .. claims_str)
end

function _M.apply_basic(user_id, nginx)
	local claims_str = claimstr.from_user_id(user_id)
  	nginx.set_auth_header("MyAuth1" .. claims_str)
end

return _M