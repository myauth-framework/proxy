anon = {
	"/pub"
}

basic = {
	{
		url = "/basic-access-[\\d]+",
		users = { "user-1", "user-2" } 
	},
	{
		url = "/basic-access-2",
		users = { "user-3", "user-4" } 
	}
}

rbac = {
	secret = "qwerty",
	rules = {
		{
			url = "/rbac-access-[\\d]+",
			roles = { "role-1", "role-2" } 
		},
		{
			url = "/rbac-access-2",
			roles = { "role-3", "role-4" } 
		}
	}
}

