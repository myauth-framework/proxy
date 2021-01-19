@echo off

docker run ^
	--network=myauth-proxy-test_default ^
	-v %cd%\script-based-test-server\test.lua:/script-based-test.lua ^
	-v %cd%\image-based-test-server\test.lua:/image-based-test.lua ^
	-v %cd%\test.lua:/test.lua ^
	--rm ^
	--name myauth-integration-tester myauth-integration-tester 