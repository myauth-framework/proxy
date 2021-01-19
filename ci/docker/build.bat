@echo off

IF [%1]==[] goto noparam

echo "Build image '%1' and 'latest'..."
docker build --no-cache --build-arg VERSION=%1 -t ozzyext/myauth-proxy:%1 -t ozzyext/myauth-proxy:latest .

goto done

:noparam
echo "Please specify image version"
goto done

:done
echo "Done!"