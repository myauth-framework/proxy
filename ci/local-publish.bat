echo off

IF [%1]==[] goto noparam

echo "Copy source ..."
xcopy /E /I /Y ..\src .\out\app

echo "Build image '%1' and 'latest'..."
docker build -t ozzyext/myauth-proxy:%1 -t ozzyext/myauth-proxy:latest .

goto done

:noparam
echo "Please specify image version"
goto done

:done
echo "Done!"