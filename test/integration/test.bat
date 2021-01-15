@echo off

docker run -v %cd%\test.lua:/test.lua --rm --name myauth-integration-tester myauth-integration-tester 
rem docker run -v %cd%\test.lua:/test.lua -it --entrypoint bash --rm --name myauth-integration-tester myauth-integration-tester 