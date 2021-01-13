@echo off

echo "Start test servers..."
docker-compose -f test-env-docker-compose.yml up -d  

echo "Done!"