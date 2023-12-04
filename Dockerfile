FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y

RUN apt-get install gpg net-tools vim zsh git wget curl sudo locales -y

# install locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN cd /opt && git clone https://github.com/Senaxius/dotfiles.git
RUN chmod a+xr /opt/dotfiles

RUN cd /tmp && git clone https://github.com/Senaxius/anyconfig.git && cd anyconfig && ./install.sh

# create anyconfig config
RUN mkdir /etc/anyconfig && touch /etc/anyconfig/anyconfig.yml
RUN echo "os: debian\ninstaller: 'sudo apt update && sudo apt install -y '\nuninstaller: 'sudo apt remove -y '\nrepo: /opt/dotfiles\ncpu: x86_64" >> /etc/anyconfig/anyconfig.yml

# install anyconfig tasks
RUN anyconfig -s -i zsh/config.yml zsh/fzf.yml zsh/ohmyzsh.yml
RUN anyconfig -s -i nvim/nvim.yml nvim/config.yml nvim/vim_alias.yml 

# install airsdk
RUN curl https://debian.parrot.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/debian.parrot.com.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/debian.parrot.com.gpg] https://debian.parrot.com/ focal main generic" | sudo tee /etc/apt/sources.list.d/debian.parrot.com.list > /dev/null
RUN apt update

RUN apt install -y parrot-airsdk-cli 

# install olympe
RUN apt-get install python3-pip libgl1 -y
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install parrot-olympe

# create user parrot
RUN useradd -m -p '' parrot
RUN usermod -aG sudo parrot

RUN chmod a+xr /opt/dotfiles -R

USER parrot
RUN anyconfig -s -i zsh/config.yml zsh/fzf.yml zsh/ohmyzsh.yml
RUN anyconfig -s -i nvim/nvim.yml nvim/config.yml nvim/vim_alias.yml 
