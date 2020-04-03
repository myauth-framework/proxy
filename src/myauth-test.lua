local iresty_test = require "resty.iresty_test"
local tb = iresty_test.new({unit_name="myauth-test"})
local cjson = require "libs.json"

local user1_basic_header = "Basic dXNlci0xOnBhc3N3b3Jk"
local user2_basic_header = "Basic dXNlci0yOnBhc3N3b3Jk"

local admin_rbac_header = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQWRtaW4iLCJteWF1dGg6Y2xpbWUiOiJDbGltZVZhbCJ9.YWXLyH2sn7d_0SQyD0ZAtsK_67reGJU5UnyEuAmaVbk"
local admin_rbac_header_wrong_sign = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQWRtaW4iLCJteWF1dGg6Y2xpbWUiOiJDbGltZVZhbCJ9.YWXLyH2sn7d_0SQyD0ZAtsK_67reGJU5UnyEuAmaVb"
local notadmin_rbac_header = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVXNlciIsIm15YXV0aDpjbGltZSI6IkNsaW1lVmFsIn0.RRbNYQXXeEpTzgyQgiJlNBHlmpsUFk7-V1mp3mGq978"

local host_header = "Host: test.host.ru"
local wrong_host_header = "Host: test.wrong-host.ru"

local m = nil;

function tb:init(  )
  m = require "myauth"
  m.strategy = require "test.myauth-test-nginx" 
  m.config = { 
    anon = { "/foo" },
    basic = {
      {
        url = "%/basic%-access%-[%d]+",
        users = { "user-1" } 
      }
    },
    rbac = {
      {
        url = "%/basic%-access%-[%d]+",
        roles = { "Admin" } 
      }
    }
   }
end

function tb:test_should_pass_anon()
   m.authorize("/foo")
end

function tb:test_should_fail_anon_if_url_not_defined()
  local v, err = pcall(m.authorize, "/bar")
  if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

function tb:test_should_pass_basic()
   m.authorize("/basic-access-1", user1_basic_header)
end

function tb:test_should_fail_basic_if_url_not_defined()
  local v, err = pcall(m.authorize, "/bar", user1_basic_header)
  if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

function tb:test_should_fail_basic_if_wrong_user_defined()
  local v, err = pcall(m.authorize, "/basic-access-1", user2_basic_header)
  if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

function tb:test_should_pass_rbac()
   m.authorize("/basic-access-1", admin_rbac_header, host_header)
end

function tb:test_should_fail_rbac_if_url_not_defined()
  local v, err = pcall(m.authorize, "/bar", admin_rbac_header, host_header);
  if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

function tb:test_should_fail_rbac_if_role_absent()
  local v, err = pcall(m.authorize, "/basic-access-1", notadmin_rbac_header, host_header);
  if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

function tb:test_should_fail_rbac_if_wrong_host()
  local v, err = pcall(m.authorize, "/basic-access-1", admin_rbac_header, wrong_host_header);
  if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

function tb:test_should_fail_rbac_if_wrong_sign()
  local v, err = pcall(m.authorize, "/basic-access-1", admin_rbac_header_wrong_sign, host_header);
  if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

-- units test
tb:run()