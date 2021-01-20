@echo off

echo "Copy sources ..."
xcopy /E /I /Y ..\src .\out

echo "Build image ..."
docker build --no-cache --build-arg VERSION=1.0.1 -t ozzyext/myauth-proxy:1.8.6 -t ozzyext/myauth-proxy:latest .

echo "Done!"