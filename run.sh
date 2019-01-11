#!/bin/sh

# Usage: ./t2t.sh image_name


nvidia-docker run -d -v $PWD/tensor2tensor:/t2t -v $PWD/data:/data -p 2222:22 -it $1
