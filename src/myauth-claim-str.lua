-- myauth-claim-str.lua

local _M = {}

local function norm_value(value)

	local norm, _ = string.gsub(value, "\"", "\\\"")
	norm, _ = string.gsub(norm, "\\\\\"", "\\\"")
	return norm;

end

function _M.from_user_id(user_id)
	
	return "sub=\"" .. user_id .. "\""

end

function _M.from_claims(claims)
	
	local res_str = ""
	for name, claim in pairs(claims) do
		if res_str ~= "" then
			res_str = res_str .. ", "
		end

		local claim_type = type(claim)
		local claim_value = ""

		if claim_type == "string" then

			claim_value = norm_value(claim)

		elseif claim_type == "table" then

			for name, claim in pairs(claim) do
				if claim_value ~= "" then
					claim_value = claim_value .. ","
				end

				claim_value = claim_value .. norm_value(claim)
			end

		else
			claim_value = "[wrong-value]";
		end


		res_str = res_str .. name .. "=\"" .. claim_value .. "\""
		

	end

	return res_str

end

return _M