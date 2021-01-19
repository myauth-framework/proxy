@echo off

echo "Start test servers..."
docker-compose -p myauth-proxy-test -f test-env-docker-compose.yml up -d  

echo "Done!"