day=`date "+%Y%m%d"`

docker build \
  --build-arg "http_proxy=http://10.24.96.33:20171" \
  --build-arg "https_proxy=http://10.24.96.33:20171" \
  -t "jicki/wine:i386-${day}" \
  -f dockerfile .

