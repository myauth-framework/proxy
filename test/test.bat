@echo off

docker run ^
	--network=myauth-proxy-test_default ^
	-v %cd%\test-server\test.lua:/test.lua ^
	--rm ^
	--name myauth-proxy-integration-tester myauth-proxy-integration-tester 