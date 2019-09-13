-- myauth-jwt-nginx.lua

NgnxStrategy = {}
NgnxStrategy.__index = NgnxStrategy

function NgnxStrategy.new()

end

function NginxStrategy.set_source_header()
  ngx.req.set_header("X-ResponseSource", "myauth-proxy")
end

function NginxStrategyexit_unauthorized(msg)
  set_source_header()
  ngx.status = ngx.HTTP_UNAUTHORIZED
  ngx.say(msg)
  ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
