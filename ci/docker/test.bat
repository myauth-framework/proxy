@echo off

IF [%1]==[] goto noparam

for %%I in (..) do set ParentFolderName=%%~fI

docker run -v %ParentFolderName%\test:/app/libs/test --rm ozzyext/myauth-proxy:%1 bash -c "cd /app/libs/test; bash test.sh"

goto done

:noparam
echo "Please specify image version"
goto done

:done
echo "Done!"