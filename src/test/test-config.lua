white_list = {
	"/free_for_access"
}

anon = {
	"/pub"
}

basic = {
	{
		id = "user-1",
		pass = "user-1-pass",
		urls = {
			"/basic-access-[%d]+",
			"/basic-access-a"
		}
	},
	{
		id = "user-2",
		pass = "user-2-pass",
		urls = {
			"/basic-access-[%d]+"			
		}
	},
	{
		id = "user-2",
		pass = "user-2-pass",
		urls = {
			"/basic-access-2"			
		}
	}
}

rbac = {
	secret = "qwerty",
	rules = {
		{
			url = "/rbac-access-[%d]+",
			roles = { "role-1", "role-2" } 
		},
		{
			url = "/rbac-access-2",
			roles = { "role-3", "role-4" } 
		}
	}
}

