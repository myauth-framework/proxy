local iresty_test = require "resty.iresty_test"
local tb = iresty_test.new({unit_name="myauth-test"})
local cjson = require "libs.json"

local user1_basic_header = "Basic dXNlci0xOnBhc3N3b3Jk"
local user2_basic_header = "Basic dXNlci0yOnBhc3N3b3Jk"

local admin_rbac_header = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQWRtaW4iLCJteWF1dGg6Y2xpbWUiOiJDbGltZVZhbCJ9.YWXLyH2sn7d_0SQyD0ZAtsK_67reGJU5UnyEuAmaVbk"
local admin_rbac_header_wrong_sign = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQWRtaW4iLCJteWF1dGg6Y2xpbWUiOiJDbGltZVZhbCJ9.YWXLyH2sn7d_0SQyD0ZAtsK_67reGJU5UnyEuAmaVb"
local notadmin_rbac_header = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNeUF1dGguT0F1dGhQb2ludCIsInN1YiI6IjBjZWMwNjdmOGRhYzRkMTg5NTUxMjAyNDA2ZTQxNDdjIiwiZXhwIjo3NTY4NDcyMDI0LjAyNjUwMiwiYXVkIjoidGVzdC5ob3N0LnJ1IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVXNlciIsIm15YXV0aDpjbGltZSI6IkNsaW1lVmFsIn0.RRbNYQXXeEpTzgyQgiJlNBHlmpsUFk7-V1mp3mGq978"

local host = "test.host.ru"
local wrong_host = "test.wrong-host.ru"

local function create_m(config)
  local m = require "myauth"
  m.strategy = require "test.myauth-test-nginx" 

  local secrets = { jwt_secret="qwerty" }

  m.initialize(config, secrets)
  return m
end

local function should_error(m, ...)
  local v, err = pcall(m.authorize_core, ...)
  if v then
      error("No expected error")
   else
      print("Actual error: " .. err)
   end
end

local function should_pass_rbac(m, ...)
  local v, err = pcall(m.authorize_core, ...);
  if not v then
    error("Error: " .. err .. ". Debug: " .. m.strategy.debug_info)
  end
end

function tb:init(  )
end

function tb:test_should_pass_anon()
  local config = {
    debug_mode=true,
    anon = { "/foo" }
  }
  local m = create_m(config)
  m.authorize_core("/foo")
end

function tb:test_should_fail_anon_if_url_not_defined()
  local config = {
    debug_mode=true,
    anon = { "/foo" }
  }
  local m = create_m(config)
  should_error(m, "/bar")
end

function tb:test_should_pass_basic()
  local config = {
    debug_mode=true,
    basic = {
      {
        id="user-1",
        pass="password",
        urls = {"/basic-access-[%d]+"}
      }
    },
  }
  local m = create_m(config)
  m.authorize_core("/basic-access-1", "GET", user1_basic_header)
end

function tb:test_should_fail_basic_if_url_not_defined()
  local config = {
    debug_mode=true,
    basic = {
      {
        id="user-1",
        pass="password",
        urls = {"/basic-access-[%d]+"}
      }
    },
  }
  local m = create_m(config)
  should_error(m, "/basic-access-notdigit", "GET", user1_basic_header)
end

function tb:test_should_fail_basic_if_wrong_user_defined()
  local config = {
    debug_mode=true,
    basic = {
      {
        id="user-1",
        pass="password",
        urls = {"/basic-access-[%d]+"}
      }
    },
  }
  local m = create_m(config)
  should_error(m, "/basic-access-notdigit", "GET", user2_basic_header)
end

function tb:test_should_pass_rbac()
  local config = {
    debug_mode=true,
    rbac = {
      rules = {
        {
          url = "/bearer-access-[%d]+",
          allow = { "Admin" } 
        }
      }
    }
  }
  local m = create_m(config)
  should_pass_rbac(m, "/bearer-access-1", "GET", admin_rbac_header, host)
end

function tb:test_should_fail_rbac_if_url_not_defined()
  local config = {
    debug_mode=true,
    rbac = {
      rules = {
        {
          url = "/bearer-access-[%d]+",
          allow = { "Admin" } 
        }
      }
    }
  }
  local m = create_m(config)
  should_error(m, "/bearer-access-notdigit", "GET", admin_rbac_header, host)
end

function tb:test_should_fail_rbac_if_role_absent()
  local config = {
    debug_mode=true,
    rbac = {
      rules = {
        {
          url = "/bearer-access-[%d]+",
          allow = { "Admin" } 
        }
      }
    }
  }
  local m = create_m(config)
  should_error(m, "/bearer-access-1", "GET", notadmin_rbac_header, host)
end

function tb:test_should_fail_rbac_if_wrong_host()
  local config = {
    debug_mode=true,
    rbac = {
      rules = {
        {
          url = "/bearer-access-[%d]+",
          allow = { "Admin" } 
        }
      }
    }
  }
  local m = create_m(config)
  should_error(m, "/bearer-access-1", "GET", admin_rbac_header, wrong_host)
end

function tb:test_should_fail_rbac_if_wrong_sign()

  local config = {
    debug_mode=true,
    rbac = {
      rules = {
        {
          url = "/bearer-access-[%d]+",
          allow = { "Admin" } 
        }
      }
    }
  }
  local m = create_m(config)
  should_error(m, "/bearer-access-1", "GET", admin_rbac_header_wrong_sign, host)
end

function tb:test_should_fail_rbac_if_in_black_list()

  local config = {
    debug_mode=true,
    black_list = {
      "/"
    },
    rbac = {
      rules = {
        {
          url = "/bearer-access-[%d]+",
          allow = { "Admin" } 
        }
      }
    }
  }
  local m = create_m(config)
  should_error(m, "/bearer-access-1", "GET", admin_rbac_header, host)
end

function tb:test_should_dont_authorize_when_in_dont_apply_for()
  local config = {
    debug_mode=true,
    dont_apply_for = {
      "/"
    },
    only_apply_for = {
      "/"
    },
    rbac = {
      rules = {
        {
          url = "/bearer-access-[%d]+",
          allow = { "Admin" } 
        }
      }
    }
  }
  local m = create_m(config)
  should_pass_rbac(m, "/bearer-access-nodigit", "GET", admin_rbac_header, host)
end

function tb:test_should_dont_authorize_when_not_in_only_apply_for()
  local config = {
    debug_mode=true,
    only_apply_for = {
      "/apply-for-this"
    },
    rbac = {
      rules = {
        {
          url = "/bearer-access-[%d]+",
          allow = { "Admin" } 
        }
      }
    }
  }
  local m = create_m(config)
  should_pass_rbac(m, "/bearer-access-nodigit", "GET", admin_rbac_header, host)
end

function tb:test_should_pass_when_allow_for_all()
  local config = {
    debug_mode=true,
    rbac = {
      rules = {
        {
          url = "/bearer-access-[%d]+",
          allow_for_all=true
        }
      }
    }
  }
  local m = create_m(config)
  should_pass_rbac(m, "/bearer-access-1", "GET", admin_rbac_header, host)
end

-- units test
tb:run()