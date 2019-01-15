#!/bin/sh

# Usage: ./t2t.sh image_name port


nvidia-docker run -d -v $PWD/tensor2tensor:/t2t -v $PWD/data:/data -p $2:22 -it $1
