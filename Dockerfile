FROM ubuntu:16.04
MAINTAINER CrackTG99 <crack.t.g.99@protonmail.com>
LABEL version="1"

# Set some env variables as we mostly work in non interactive mode
RUN echo "export VISIBLE=now" >> /etc/profile

# Update system and install Supervisord, OpenSSH server, and tools needed for creepMiner
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
  && apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confold" \
  apt-utils supervisor sudo \
  net-tools openssh-server \
  build-essential cmake git \
  python-setuptools python-dev \
  openssl libssl-dev \
  xz-utils curl ca-certificates gnupg2 dirmngr \
  wget ocl-icd-opencl-dev

# build and install creepMiner
RUN cd /tmp/ \
  && wget https://bootstrap.pypa.io/get-pip.py \
  && python get-pip.py \
  && pip install conan \
  && wget https://github.com/Creepsky/creepMiner/archive/1.7.19.tar.gz \
  && tar -zxvf 1.7.19.tar.gz \
  && cd creepMiner-1.7.19 \
  && conan install . -s compiler.libcxx=libstdc++11 --build=missing \
  && cmake CMakeLists.txt -DMINIMAL_BUILD=ON -DUSE_SSE4=OFF \
  && make \
  && cp -r src/shabal/opencl/mining.cl /usr/local/sbin/ \
  && cp -r bin/creepMiner /usr/local/sbin/ \
  && cp -r resources/public /usr/local/sbin/ \
  && mkdir /config && mkdir /logs

# Add init and supervisord config
ADD resources/init /sbin/init
ADD resources/supervisord.conf /etc/supervisor/supervisord.conf
ADD resources/mining.conf /usr/local/sbin/omining.conf

RUN chmod 755 /sbin/init

# Add creepUser | creep / M1n3r and set root password
RUN useradd -m -p FIEyX7IsHWazs -s /bin/bash creep \
  && echo 'root:toor' | chpasswd

# Expose port 8124 for creepMiner UI, 9001 for supervisord
EXPOSE 8124 9001

# Use baseimage-docker's init system.
CMD ["/sbin/init"]

# Clean up APT when done.
RUN apt-get autoclean -o Dpkg::Options::="--force-confold" \
  && apt-get autoremove -o Dpkg::Options::="--force-confold"

