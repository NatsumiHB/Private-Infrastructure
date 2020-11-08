@echo off

docker network create nginx-net
cd booru
docker-compose up -d
cd ..
cd docker-registry
docker-compose up -d
cd ..
cd gitlab
docker-compose up -d
cd ..
cd nextcloud
docker-compose up -d
cd ..
cd nginx
docker-compose up -d
cd ..