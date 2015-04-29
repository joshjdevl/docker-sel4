FROM ubuntu:trusty
MAINTAINER josh < josh [at] gmail {dot} com>

#http://sel4.systems/CAmkES/GettingStarted.pml#prerequisites

RUN apt-get update && apt-get -y install python-software-properties software-properties-common && \
add-apt-repository "deb http://gb.archive.ubuntu.com/ubuntu $(lsb_release -sc) universe" && \
apt-get update

RUN add-apt-repository ppa:saiarcot895/myppa && \
apt-get update && \
apt-get -y install apt-fast

RUN apt-get clean && apt-fast update
RUN apt-fast -y install wget curl

RUN apt-fast -y install build-essential git
RUN apt-fast -y install libxml2-utils qemu realpath python python-pip python-tempita cabal-install realpath libxml2-utils qemu git python-jinja2 python-ply
RUN apt-fast -y install lib32z1 lib32ncurses5 lib32bz2-1.0

RUN cd /tmp
RUN mkdir -p /opt/local
RUN wget https://sourcery.mentor.com/public/gnu_toolchain/arm-none-eabi/arm-2013.11-24-arm-none-eabi-i686-pc-linux-gnu.tar.bz2
RUN tar xf arm-2013.11-24-arm-none-eabi-i686-pc-linux-gnu.tar.bz2
RUN mv arm-2013.11 /opt/local/

RUN pip install --user pyelftools

RUN cabal update
RUN cabal install MissingH data-ordlist split

RUN mkdir -p $HOME/bin
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > $HOME/bin/repo
RUN chmod a+x $HOME/bin/repo

ENV PATH /opt/local/arm-2013.11/bin:$HOME/bin:$PATH


RUN mkdir $HOME/camkes-project
RUN cd $HOME/camkes-project
RUN git config --global user.name "test"
RUN git config --global user.email "test"
RUN git config --global color.ui false 
RUN cd $HOME/camkes-project && $HOME/bin/repo init -u https://github.com/seL4/camkes-manifest.git
RUN cd $HOME/camkes-project && $HOME/bin/repo sync

