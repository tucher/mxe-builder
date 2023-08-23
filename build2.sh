TAG=gcc13-2
IMAGE_NAME=mxe-builder
ACCOUNT=tucher
docker build --platform linux/amd64 --push -t $ACCOUNT/$IMAGE_NAME:$TAG-amd64 --progress=plain . & pid1=$!
docker build --platform linux/arm64 --push -t $ACCOUNT/$IMAGE_NAME:$TAG-arm64 --progress=plain . & pid2=$!

# Wait for command1 to finish
wait $pid1
status1=$?

# Wait for command2 to finish
wait $pid2
status2=$?

# Check the exit status of both commands
if [ $status1 -ne 0 ] || [ $status2 -ne 0 ]; then
    echo "One or both commands failed."
    exit 1
fi

docker manifest create -a $ACCOUNT/$IMAGE_NAME:$TAG $ACCOUNT/$IMAGE_NAME:$TAG-amd64 $ACCOUNT/$IMAGE_NAME:$TAG-arm64
docker manifest annotate $ACCOUNT/$IMAGE_NAME:$TAG $ACCOUNT/$IMAGE_NAME:$TAG-amd64 --os linux --arch amd64
docker manifest annotate $ACCOUNT/$IMAGE_NAME:$TAG $ACCOUNT/$IMAGE_NAME:$TAG-arm64 --os linux --arch arm64

docker manifest push $ACCOUNT/$IMAGE_NAME:$TAG
