local iresty_test = require "resty.iresty_test"
local tb = iresty_test.new({unit_name="myauth-jwt-test"})

local m = require "myauth-jwt"

local token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwicm9sZXMiOlsicm9vdCIsIkFkbWluIl0sIm15YXV0aDpjbGltZSI6IkNsaW1lVmFsIn0.u2d7kkDW6MrZLZP48GMeyiOusrp0wNr-1AMC4LBTl6g"
local wrong_token = "babla"
local host = "test.host.ru"

m.strategy = require "test.myauth-test-nginx"
m.secret = "qwerty"

function tb:init(  )
    self:log("init complete")
end

function tb:test_should_not_authorize_wrong_token()
   local v, err = pcall(m.authorize_roles, wrong_token)
   
   if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

function tb:test_should_not_authorize_wrong_secret()
   local secret_cache = m.secret
   m.secret = "wrong_secret"

   local v, err = pcall(m.authorize_roles, token);

   if v then
      m.secret = secret_cache
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

function tb:test_should_authorize_for_role()
      m.authorize_roles(token, host, {"Admin", "Admin2"})
end

function tb:test_should_not_authorize_for_wrong_role()
   local v, err = pcall(m.authorize_roles, token, host, {"Wrong role"})
   if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end


-- units test
tb:run()