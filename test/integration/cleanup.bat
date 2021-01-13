@echo off

echo "Stop test servers..."
docker-compose -f test-env-docker-compose.yml down

echo "Done!"