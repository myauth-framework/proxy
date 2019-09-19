-- mylab-jwt-test.lua

local iresty_test = require "resty.iresty_test"
local tb = iresty_test.new({unit_name="myauth-jwt-test"})

require "myauth-jwt-test-nginx"
local m = require "myauth-jwt"
--local auth_header = "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDA4MDE5LjIyNzk3MiwibXlhdXRoOnJvbGVzIjpbIkFkbWluIl0sIm15YXV0aDpjbGltZXMiOlt7Ik5hbWUiOiJDbGltZSIsIlZhbHVlIjoiQ2xpbWVWYWwifV19.ghkNFgD7381m7aqEmEMl4tQcSDEQ3CX-d8zksTPcI6A"
local auth_header = "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwibXlhdXRoOnJvbGVzIjpbIkFkbWluIl0sIm15YXV0aDpjbGltZXMiOlt7Ik5hbWUiOiJDbGltZSIsIlZhbHVlIjoiQ2xpbWVWYWwifV19.M9e88RtulUkcsh0VzXY4KhGiZiKL9Pd0xiIXYGwaDEY"

m.strategy = require "myauth-jwt-test-nginx"
m.secret = "qwerty"

function tb:init(  )
    self:log("init complete")
end

function tb:test_should_authorize_token()
   	m.authorize_header(auth_header)
end

function tb:test_should_not_authorize_wrong_token()
   	if(pcall(m.authorize_header, "Authorization: Bearer blabla")) then
   		error("Fail");
   	end
end

function tb:test_should_not_authorize_wrong_secret()
	local secret_cache = m.secret
	m.secret = "wrong_secret"
   	if(pcall(m.authorize_header, auth_header)) then
   		m.secret = secret_cache
   		error("Fail");
   	end
end

function tb:test_should_authorize_for_role()
   	m.authorize_header_for_roles(auth_header, "Admin", "Admin2")
end

function tb:test_should_not_authorize_for_wrong_role()
      if(pcall(m.authorize_header_for_roles, auth_header, "Wrong role")) then
         error("Fail");
      end
end


-- units test
tb:run()