-- myauth-jwt-test.lua
-- Unit tests

lu = require "libs.luaunit"

local m = require "myauth-jwt"
local auth_header = "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJDbGltZSI6IkNsaW1lVmFsIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQWRtaW4iLCJzdWIiOiIyYmJkZGZjNmE2Njg0OTJlYmFjNTU1YTI4ZTczODFlMSIsIm5iZiI6MTU3MjQ1MTcxOCwiZXhwIjoxNTc4NDUxNzE4LCJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsImF1ZCI6InRlc3QuaG9zdC5ydSJ9.SMRYoIcN6iDxTpOV3IP2RZ_BB5xeVTy1DU1vnuu0A-M"
local host_header = "Host: test.host.ru"

m.strategy = require "tests.test-nginx"
m.secret = "qwertyqwertyqwerty"

JwtTest = {}

function JwtTest:test_should_authorize_token()
   	m.authorize_header(auth_header, host_header)
end

function JwtTest:test_should_not_authorize_wrong_token()
   	if(pcall(m.authorize_header, host_header, "Authorization: Bearer blabla")) then
   		error("Fail");
   	end
end

function JwtTest:test_should_not_authorize_wrong_secret()
	local secret_cache = m.secret
	m.secret = "wrong_secret"
   	if(pcall(m.authorize_header, host_header, auth_header)) then
   		m.secret = secret_cache
   		error("Fail");
   	end
end

function JwtTest:test_should_authorize_for_role()
   	m.authorize_header_for_roles(auth_header, host_header, "Admin", "Admin2")
end

function JwtTest:test_should_not_authorize_for_wrong_role()
      if(pcall(m.authorize_header_for_roles, auth_header, host_header, "Wrong role")) then
         error("Fail");
      end
end


-- units test
os.exit( lu.LuaUnit.run("JwtTest") )