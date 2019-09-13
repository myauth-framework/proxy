-- mylab-jwt-test.lua

local iresty_test = require "resty.iresty_test"
local tb = iresty_test.new({unit_name="myauth-jwt-test"})

require "myauth-jwt-test-nginx"
local m = require "myauth-jwt"
local test_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDA4MDE5LjIyNzk3MiwibXlhdXRoOnJvbGVzIjpbIkFkbWluIl0sIm15YXV0aDpjbGltZXMiOlt7Ik5hbWUiOiJDbGltZSIsIlZhbHVlIjoiQ2xpbWVWYWwifV19.ghkNFgD7381m7aqEmEMl4tQcSDEQ3CX-d8zksTPcI6A"

m.set_strategy(TestNginxStrategy())

function tb:init(  )
    self:log("init complete")
end

function tb:test_should_authorize_token()
   	m.authorize_header("Authorization: Bearer " .. test_token)
end

function tb:test_should_not_authorize_wrong_token()
   	m.authorize_header("Authorization: Bearer blabla")
end


-- units test
tb:run()