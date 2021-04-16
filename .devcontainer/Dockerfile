# [Choice] Ubuntu version: bionic, focal
ARG VARIANT="focal"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

RUN apt-get update \ 
    && sudo apt-get purge -y --auto-remove git \
    && apt-get install -y gcc binutils make libssl-dev pkg-config python3-pip libcurl4-openssl-dev libexpat1-dev gettext ruby-full

# Create the user
ARG USERNAME=testuser
ARG USER_UID=1003
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************
# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
ARG  HOMEDIR=/home/$USERNAME

WORKDIR $HOMEDIR

# set shared folder
RUN mkdir -p  $HOMEDIR/persist_data

## Install git
RUN wget https://github.com/git/git/archive/master.zip
RUN unzip master.zip 
WORKDIR $HOMEDIR/git-master
RUN make prefix=/usr/local all
RUN sudo make prefix=/usr/local install
WORKDIR $HOMEDIR
RUN rm -f master.zip
RUN rm -rf $HOMEDIR/git-master

## Install AWSCLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN sudo $HOMEDIR/aws/install
RUN rm -f awscliv2.zip
RUN rm -rf $HOMEDIR/aws

## Install RUST SDK
ENV RUST_VERSION stable
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain $RUST_VERSION -y 
## Install RUST plugin
#RUN rustup default stable
#RUN curl https://static.rust-lang.org/dist/rust-1.51.0-x86_64-unknown-linux-gnu.tar.gz -o rust-1.51.0-x86_64-unknown-linux-gnu.tar.gz
#RUN tar -zxvf rust-1.51.0-x86_64-unknown-linux-gnu.tar.gz
#RUN sudo sh $HOMEDIR/rust-1.51.0-x86_64-unknown-linux-gnu/install.sh
#RUN rm -f rust_temp.tar.gz
#RUN rm -rf $HOMEDIR/rust_temp

ENV PATH $PATH:$HOMEDIR/.cargo/bin
RUN cargo install --force cargo-make

## node.js param for install
ENV NVM_DIR $HOMEDIR/.nvm
ENV NODE_VERSION 12.22.1

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.38.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm update -g npm \
    && npm install -g npm

# SET PATH
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $PATH:$NODE_PATH
ENV PATH      $PATH:$NVM_DIR/versions/node/v$NODE_VERSION/bin

# Install node-js plugin
RUN npm install -g @aws-amplify/cli
RUN npm install -g serverless
RUN npm install -g typescript
RUN npm install -g aws-cdk

## Install git-remote-codecommit
RUN pip3 install -U pip &&\
  pip3 install --no-cache-dir git-remote-codecommit
