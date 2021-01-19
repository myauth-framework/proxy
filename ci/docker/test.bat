@echo off

IF [%1]==[] goto noparam

xcopy /E /I /Y ..\..\test\unit .\out\test

docker run -v %cd%\out\test:/app/libs/test --rm ozzyext/myauth-proxy:%1 bash -c "cd /app/libs/test; bash test.sh"

goto done

:noparam
echo "Please specify image version"
goto done

:done
echo "Done!"