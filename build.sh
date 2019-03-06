docker build  -t mxe-builder .
docker tag mxe-builder tucher/mxe-builder
docker push tucher/mxe-builder
