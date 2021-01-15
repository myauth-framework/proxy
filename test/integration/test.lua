local iresty_test = require "resty.iresty_test"
local tb = iresty_test.new({unit_name="myauth-integration-test"})
local cjson = require "cjson"
local curl = require "lcurl"

local user1_basic_header = "Basic dXNlci0xOnBhc3N3b3Jk"
local user2_basic_header = "Basic dXNlci0yOnBhc3N3b3Jk"

local admin_rbac_header = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1Iiwicm9sZXMiOlsiQWRtaW4iXSwibXlhdXRoOmNsaW1lIjoiQ2xpbWVWYWwifQ.KUM0RXlvphoDHQPvLZD3E1HwVVZoejSm5kfrOSsIrEg"
local admin_rbac_header_wrong_sign = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1Iiwicm9sZXMiOlsiQWRtaW4iXSwibXlhdXRoOmNsaW1lIjoiQ2xpbWVWYWwifQ.sYgnefh7qS0BxfrLNvOeEyzyL9SqumXKywXjwm60ecY"
local notadmin_rbac_header = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1Iiwicm9sZXMiOlsiVXNlciJdLCJteWF1dGg6Y2xpbWUiOiJDbGltZVZhbCJ9.flQg_Vwbk2cemeKyiI-L7vodfLWln1fWpjxat6w_c6A"

local host = "test.host.ru"
local wrong_host = "test.wrong-host.ru"

local debug_mode = false

function tb:init(  )
end

function tb:test_should_pass_anon()
	error("TA-DA")
end

-- units test
tb:run()

print("test print")