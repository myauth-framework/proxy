local iresty_test = require "resty.iresty_test"
local tb = iresty_test.new({unit_name="myauth-claims-test"})

local claim_str = require "myauth-claim-str"

function tb:test_should_deserialize_user_id()
	  	
	local str = claim_str.from_user_id("user-id")
	assert(str == "sub=\"user-id\"", "Actual: '".. str .. "'")

end

function tb:test_should_deserialize_user_id_from_claims()
	  	
	local claims = {
		sub="user-id"
	} 

	local str = claim_str.from_claims(claims)
	assert(str == "sub=\"user-id\"", "Actual: '".. str .. "'")

end

function tb:test_should_normclaim_value()
	  	
	local claims = {
		sub="user\"id\""
	} 

	local str = claim_str.from_claims(claims)
	assert(str == "sub=\"user\\\"id\\\"\"", "Actual: '".. str .. "'")

end

function tb:test_should_deserialize_mutiple_claims_from_claims()
	  	
	local claims = {
		sub="user-id",
		aud="host.ru"
	} 

	local str = claim_str.from_claims(claims)
	assert(str == "aud=\"host.ru\", sub=\"user-id\"", "Actual: '".. str .. "'")

end

function tb:test_should_deserialize_array()
	  	
	local claims = {
		sub="user-id",
		roles= { "admin", "user" }
	} 

	local str = claim_str.from_claims(claims)
	assert(str == "roles=\"admin,user\", sub=\"user-id\"", "Actual: '".. str .. "'")

end

-- units test
tb:run()