local iresty_test = require "resty.iresty_test"
local tb = iresty_test.new({unit_name="myauth-jwt-test"})

local m = require "myauth-jwt"

local token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQWRtaW4iLCJteWF1dGg6Y2xpbWUiOiJDbGltZVZhbCJ9.y8QQl0HiNhR3-Ra8j8_xMAOnyUgl8KpPodR20ya8JvQ"
local host = "test.host.ru"

m.strategy = require "test.myauth-test-nginx"
m.secret = "qwerty"

function tb:init(  )
    self:log("init complete")
end

function tb:test_should_not_authorize_wrong_token()
   local v, err = pcall(m.authorize_header, "Authorization: Bearer blabla")
   
   if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

function tb:test_should_not_authorize_wrong_secret()
   local secret_cache = m.secret
   m.secret = "wrong_secret"

   local v, err = pcall(m.authorize_header, token);

   if v then
      m.secret = secret_cache
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

function tb:test_should_authorize_for_role()
      m.authorize_header_for_roles(token, host, "Admin", "Admin2")
end

function tb:test_should_not_authorize_for_wrong_role()
   local v, err = pcall(m.authorize_header_for_roles, token, host, "Wrong role")
   if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end


-- units test
tb:run()