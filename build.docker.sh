#! /bin/bash

day=`date "+%Y%m%d"`

cd docker-wine/ubuntu
docker build \
  --build-arg "http_proxy=http://10.24.96.33:20171" \
  --build-arg "https_proxy=http://10.24.96.33:20171" \
  -t "jicki/wine:i386-${day}" \
  -f dockerfile .
cd ..

cd i386
docker build \
  --build-arg "VERSION=${day}" \
  --build-arg "http_proxy=http://10.24.96.33:20171" \
  --build-arg "https_proxy=http://10.24.96.33:20171" \
  -t jicki/deepin-wine:i386-${day} \
  -f Dockerfile .
cd ../../

docker build \
  --build-arg "VERSION=${day}" \
  --build-arg "http_proxy=http://10.24.96.33:20171" \
  --build-arg "https_proxy=http://10.24.96.33:20171" \
  -t jicki/docker-wechat:${day} \
  -f Dockerfile .


# update image
sed -i "s/image:.*/image: jicki\/docker-wechat:${day}/g" docker-compose.yml

# sudo docker push -a jicki/wine
