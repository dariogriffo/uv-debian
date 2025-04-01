uv_VERSION=$1
BUILD_VERSION=$2
declare -a arr=("bookworm" "trixie" "sid")
for i in "${arr[@]}"
do
  DEBIAN_DIST=$i
  FULL_VERSION=$uv_VERSION-${BUILD_VERSION}+${DEBIAN_DIST}_amd64
docker build . -t uv-$DEBIAN_DIST  --build-arg DEBIAN_DIST=$DEBIAN_DIST --build-arg uv_VERSION=$uv_VERSION --build-arg BUILD_VERSION=$BUILD_VERSION --build-arg FULL_VERSION=$FULL_VERSION
  id="$(docker create uv-$DEBIAN_DIST)"
  docker cp $id:/uv_$FULL_VERSION.deb - > ./uv_$FULL_VERSION.deb
  tar -xf ./uv_$FULL_VERSION.deb
done


