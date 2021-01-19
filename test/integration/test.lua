local iresty_test = require "resty.iresty_test"
local tb = iresty_test.new({unit_name="myauth-integration-test"})
local prettyjson = require "resty.prettycjson"

local http = require('socket.http')	

local user1_basic_header = "Basic dXNlci0xOnBhc3N3b3Jk"
local user2_basic_header = "Basic dXNlci0yOnBhc3N3b3Jk"

local user1_rbac_header = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1Iiwicm9sZXMiOlsiVXNlcjEiXSwibXlhdXRoOmNsaW1lIjoiQ2xpbWVWYWwifQ.l4XBPKoVe40NvyHIK5vZkYFo1wZrr4ZZyJaVwQmapVM"
local user2_rbac_header = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1Iiwicm9sZXMiOlsiVXNlcjIiXSwibXlhdXRoOmNsaW1lIjoiQ2xpbWVWYWwifQ.lsDQCGiKFUKyyJu3sdtVXAvGwgk7tMQDWPVF5Bt0WE0"
local user3_rbac_header = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1Iiwicm9sZXMiOlsiVXNlcjMiXSwibXlhdXRoOmNsaW1lIjoiQ2xpbWVWYWwifQ.bsDImRiKSl2bmeAEJkVyLVM4sLijKGWMEw5LrbFzXso"
local user3_wrongsign_rbac_header = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1Iiwicm9sZXMiOlsiVXNlcjMiXSwibXlhdXRoOmNsaW1lIjoiQ2xpbWVWYWwifQ.bsDImRiKSl2bmeAEJkVyLVM4sLijKGWMEw5LrbFzXsX"

local host = "test.host.ru"
local wrong_host = "test.wrong-host.ru"

local debug_mode = true

function check_code(actual_code, expected_code)
	if(actual_code ~= expected_code) then
		error('Met unexpected response status code: "' ..  actual_code .. '". But expected is "' .. expected_code .. '"')
	end
end

function check_url(path, expected_code, auth_header, method)

	local resp = {}
	local body, code, headers, status = http.request {

		method = method,
		url = "http://myauth-proxy-test-server/" .. path,
		headers = {
			Authorization = auth_header
		},
		sink = ltn12.sink.table(resp) 
	}

	if (debug_mode) then
		print('')
		print('Response: ' .. status)
		print('')
		print(prettyjson(headers))
		print('')
		print(prettyjson(resp))
	end

	check_code(code, expected_code)
end

function tb:init(  )
end

function tb:test_should_allow_for_dont_apply_for()
	check_url("free_for_access", 200)
end

function tb:test_should_allow_for_anon()
	check_url("free_for_access", 200)
end

function tb:test_should_deny_for_blacklist()
	check_url("blocked", 403)
end

function tb:test_should_rbac_allow_for_all_methods()
	check_url("rbac-access-1", 200, user1_rbac_header)
end

function tb:test_should_rbac_deny_for_all_methods()
	check_url("rbac-access-1", 403, user2_rbac_header)
end

function tb:test_should_rbac_allow_for_special_methods()
	check_url("rbac-access-1", 200, user3_rbac_header)
end

function tb:test_should_rbac_deny_for_special_method()
	check_url("rbac-access-1", 403, user1_rbac_header, "POST")
end

function tb:test_should_rbac_allow_for_all()
	check_url("rbac-access-allow", 200, user2_rbac_header, "POST")
end

-- units test
tb:run()