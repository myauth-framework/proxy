echo off

IF [%1]==[] goto noparam

echo "Publish image '%1' ..."
docker push ozzyext/myauth-proxy:%1

echo "Publish image 'latest' ..."
docker push ozzyext/myauth-proxy:latest

goto done

:noparam
echo "Please specify image version"
goto done

:done
echo "Done!"