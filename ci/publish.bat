echo off

IF [%1]==[] goto noparam

echo "Copy source ..."
xcopy /E /I ..\src .\out\app

echo "Build image '%1' and 'latest'..."
docker build -t ozzyext/mylab-proxy:%1 -t ozzyext/mylab-proxy:latest .

echo "Publish image '%1' ..."
docker push ozzyext/mylab-proxy:%1

echo "Publish image 'latest' ..."
docker push ozzyext/mylab-proxy:latest

goto done

:noparam
echo "Please specify image version"
goto done

:done
echo "Done!"