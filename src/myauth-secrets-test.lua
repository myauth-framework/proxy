local iresty_test = require "resty.iresty_test"
local tb = iresty_test.new({unit_name="myauth-secrets-test"})
local cjson = require "libs.json"

local m = require "myauth-secrets"

function tb:init(  )
    m.load("test\\test-secrets.lua")
end

function tb:test_should_load_jwt_secret()
   if(m.jwt_secret ~= "some-secret") then
      error("Jwt secret not found")
   end
end

-- units test
tb:run()