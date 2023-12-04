# Installation
## 1. Install docker
#### On debian-based systems (Ubuntu,...):
``` bash
sudo apt update && sudo apt install docker
```
#### On arch-based systems:
``` bash
sudo pacman -Sy docker
```
#### On everything else:
Visit: <https://docs.docker.com/engine/install/>
## 2. Get Image
#### From docker-hub (recomended):
``` bash
docker pull alexminor/parrot-dev:latest
```
#### Build yourself(might take a long time):
``` bash
git clone https://github.com/AlexMinor/parrot-dev.git
cd parrot-dev
docker build --tag parrot-dev .
```
## 3. Start the container for the first time
Important: All Files saved in the docker container will get deleted everytime the container recreates, so create a volume to save your stuff in!
#### Create folder to save work
``` bash
cd <where-you-want> && mkdir <name>
cd <name> && pwd
# put this path in the next command
```
#### Start container
``` bash
docker run -it --name parrot-dev -v <path>:/home/parrot/ --net=host --privileged -e "TERM=xterm-256color" --add-host 'parrot-dev:127.0.1.1' --add-host 'anafi-ai.local:192.168.42.1' -h parrot-dev --user parrot parrot-dev:latest /bin/zsh
```
## 4. To open the container after this
``` bash
docker start parrot-dev
docker exex --user parrot -it parrot-dev /bin/zsh
```
