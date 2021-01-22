@echo off

echo "Stop test servers..."
docker-compose -p myauth-proxy-test -f test-env-docker-compose.yml down

echo "Done!"