echo off

IF [%1]==[] goto noparam

echo "Copy sources ..."
xcopy /E /I /Y ..\src .\out

echo "Build image ..."
docker build --no-cache --build-arg MYAUTH_LUA_VERSION=1.2.6 -t ozzyext/myauth-proxy:%1 -t ozzyext/myauth-proxy:latest .

goto done

:noparam
echo "Please specify image version"
goto done

:done
echo "Done!"