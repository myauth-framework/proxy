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
      error("Basic items not found")
   end
   if(first.url ~= "/basic%-access%-[%d]+") then
      error("Basic item's URL not loaded")
   end
   if(first.users == nil or first.users[1] == nil) then
      error("Basic item's users not loaded")
   end
   if(first.users[1] ~= "user-1" or first.users[2] ~= "user-2") then
      error("Basic item's users loaded incorrectly")
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

   -- print("Rbac object: " .. cjson.encode(m.rbac))

   local first = m.rbac.rules[1]

   if(first == nil) then
      error("RBAC rules not found")
   end
   if(first.url ~= "/rbac%-access%-[%d]+") then
      error("RBAC rule's URL not loaded")
   end
   if(first.roles == nil or first.roles[1] == nil) then
      error("RBAC rule's roles not loaded")
   end
   if(first.roles[1] ~= "role-1" or first.roles[2] ~= "role-2") then
      error("RBAC rule's roles loaded incorrectly")
   end
end

-- units test
tb:run()