FROM buildpack-deps

RUN apt-get update && apt-get upgrade -y

RUN apt-get install gcc g++ make -y

RUN apt-get install mono-complete -y

RUN apt-get install golang -y

RUN apt-get install default-jdk -y

RUN apt-get install php -y

RUN apt-get install python python3 -y

RUN apt-get install ruby -y

RUN apt-get install rustc -y

RUN apt-get install scala -y

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

RUN npm install -g typescript

RUN set -xe && \
  apt-get update && apt-get install -y locales && \
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN set -xe && \
  apt-get update && apt-get install -y libcap-dev && \
  git clone https://github.com/ioi/isolate.git /tmp/isolate && \
  cd /tmp/isolate && \
  git checkout 18554e83793508acd1032d0cf4229a332c43085e && \
  echo "num_boxes = 2147483647" >> default.cf && \
  make install && \
  rm -rf /tmp/isolate
ENV BOX_ROOT /var/local/lib/isolate

