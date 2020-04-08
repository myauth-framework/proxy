local iresty_test = require "resty.iresty_test"
local tb = iresty_test.new({unit_name="myauth-config-test"})
local cjson = require "libs.json"

local m = require "myauth-config"

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function tb:init(  )
    m.load("test\\test-config.lua")
end

function tb:test_should_load_anon()
   if(m.anon == nil) then
      error("Anon settings not found")
   end

   -- print("Anon object: " .. cjson.encode(m.anon))

   if(not has_value(m.anon, "/pub"))then
      error("Anon item not found")
   end
end

function tb:test_should_load_basic()
   if(m.basic == nil) then
      error("Basic auth settings not found")
   end

   --print("Basic object: " .. cjson.encode(m.basic))

   local first = m.basic[1]
   if(first == nil) then
      error("Basic users not found")
   end
   if(first.id ~= "user-1") then
      error("Basic users's id not loaded")
   end
   if(first.pass ~= "user-1-pass") then
      error("Basic users's password not loaded")
   end
   if(first.urls == nil or first.urls[1] == nil) then
      error("Basic user's urls not loaded")
   end
   if(first.urls[1] ~= "/basic-access-[%d]+" or first.urls[2] ~= "/basic-access-a") then
      error("Basic usesr's urls loaded incorrectly")
   end
end

function tb:test_should_load_rbac()
   if(m.rbac == nil) then
      error("RBAC settings not found")
   end

   if(m.rbac.rules == nil) then
      error("RBAC rules settings not loaded")
   end

   if(m.rbac.secret ~= "qwerty") then
      error("Wrong RBAC secret")
   end

   if(m.rbac.ignore_audience ~= true) then
      error("Wrong RBAC ignore_audience")
   end

   -- print("Rbac object: " .. cjson.encode(m.rbac))

   local first = m.rbac.rules[1]

   if(first == nil) then
      error("RBAC rules not found")
   end
   if(first.url ~= "/rbac-access-[%d]+") then
      error("RBAC rule's URL not loaded")
   end
   if(first.roles == nil or first.roles[1] == nil) then
      error("RBAC rule's roles not loaded")
   end
   if(first.roles[1] ~= "role-1" or first.roles[2] ~= "role-2") then
      error("RBAC rule's roles loaded incorrectly")
   end
end

function tb:test_should_load_white_list()

  if(m.white_list == nil) then
      error("White list not loaded")
   end
   if(m.white_list[1] ~= "/free_for_access") then
      error("White list items loaded incorrectly")
   end

end

function tb:test_should_load_black_list()

  if(m.black_list == nil) then
      error("Black list not loaded")
   end
   if(m.black_list[1] ~= "/blocked") then
      error("Black list items loaded incorrectly")
   end

end

-- units test
tb:run()