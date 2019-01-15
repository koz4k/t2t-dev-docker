#!/bin/sh

# Usage: ./t2t.sh image_name password


nvidia-docker run -d -e PASSWORD=$3 -v $PWD/tensor2tensor:/t2t -v $PWD/data:/data -p $2:22 -it $1
