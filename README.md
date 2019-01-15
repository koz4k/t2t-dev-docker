# t2t-dev-docker

Instructions for setting up docker on remote machine.

Variables:
```
export $HOST=user@ip
export $PORT=2223  # define locally, and on remote
```

#### 1) Setup docker on Host
```bash

ssh $HOST

docker pull awarelab/t2t-dev

mkdir t2t_docker_setup
cd t2t_docker_setup

git clone https://github.com/koz4k/t2t-dev-docker.git
# pull tensor2tensor with player.py
git clone https://github.com/tensorflow/tensor2tensor.git
# or your fork e.g.
# git clone https://githubcom/deepsense-ai/tensor2tensor.git
# but you need to set upstream, pull appropriate branch etc.

mkdir data  # Keep experiment data here.

# This runs docker and mounts folders
#       data -> /data
#       tensor2tensor -> /t2t
# Note that this script is simple to modify.
bash t2t-dev-docker/run.sh awarelab/t2t-dev $PORT YOUR_PASSWORD
```

#### 2) Log into docker.
```
# Setup ssh tunneling.
ssh -N -f -L localhost:$PORT:localhost:$PORT $HOST

# log directly to docker from localhost
ssh -X -p $PORT root@localhost
password: root
```

#### 3) Example usage: player.py

```
export CUDA_VISIBLE_DEVICES=0 (or whatever is free)

# Insert experiment data in HOST ../t2t_docker_setup/data

# run player with something like
cd /t2t
python tensor2tensor/rl/player.py \
				  --wm_dir=$WM_DIR \
				  --episodes_data_dir=$DATA_DIR \
                  --loop_hparams_set=rlmb_ppo_base \

# All directories should be in mounted /data folder.
# For information about using player see tensor2tensor/rl/player.py
```
