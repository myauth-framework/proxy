rockspec_format = '3.0'
package = 'myauth'
version = '1.8.6-0'
source = {
  url = 'git://github.com/ozzy-ext-myauth/proxy',
  tag = 'master'
}
description = {
  summary = 'Provides authorization for nginx based on config',
  detailed = [[
    Requires an nginx build
    with the ngx_lua module.
  ]],
  homepage = 'https://github.com/ozzy-ext-myauth/proxy',
  license = 'The MIT License (MIT)'
}
dependencies = {
  'base64 >= 1.5',
  'lua-resty-jwt >= 0.2.2',
  'lua-resty-test >= 0.1',
  'luafilesystem >= 1.8.0'
}
build = {
  type = 'builtin',
  modules = {
    ['myauth'] = 'lib/myauth.lua',
    ['myauth.claim-str'] = 'lib/myauth/claim-str.lua',
    ['myauth.config'] = 'lib/myauth/config.lua',
    ['myauth.jwt'] = 'lib/myauth/jwt.lua',
    ['myauth.nginx'] = 'lib/myauth/nginx.lua',
    ['myauth.scheme-v1'] = 'lib/myauth/scheme-v1.lua',
    ['myauth.scheme-v2'] = 'lib/myauth/scheme-v2.lua',
    ['myauth.secrets'] = 'lib/myauth/secrets.lua',
  }
}