FROM ubuntu:trusty
MAINTAINER josh < josh [at] gmail {dot} com>

RUN apt-get update && apt-get -y install python-software-properties software-properties-common && \
add-apt-repository "deb http://gb.archive.ubuntu.com/ubuntu $(lsb_release -sc) universe" && \
apt-get update

RUN add-apt-repository ppa:saiarcot895/myppa && \
apt-get update && \
apt-get -y install apt-fast

RUN apt-fast -y install wget

RUN apt-fast -y install build-essential lib32z1 lib32ncurses5 lib32bz2-1.0 python python-pip python-tempita cabal-install realpath libxml2-utils qemu git python-jinja2 python-ply

RUN pushd /tmp
RUN mkdir -p /opt/local
RUN wget https://sourcery.mentor.com/public/gnu_toolchain/arm-none-eabi/arm-2013.11-24-arm-none-eabi-i686-pc-linux-gnu.tar.bz2
RUN tar xf arm-2013.11-24-arm-none-eabi-i686-pc-linux-gnu.tar.bz2
RUN mv arm-2013.11 /opt/local/
RUN popd

RUN pip install --user pyelftools

RUN cabal update
RUN cabal install MissingH data-ordlist split

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
RUN chmod a+x ~/bin/repo

ENV PATH /opt/local/arm-2013.11/bin:~/bin:$PATH

