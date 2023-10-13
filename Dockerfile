FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y tzdata && \
    apt-get install -y \
    git \
    vim \
    tmux \
    libsndfile-dev \
    apt-utils \
    python3.8 \
    python3.8-dev \
    python3-pip \
    python3-wheel \
    python3-setuptools \
    python3-tk && \
    apt clean autoclean && \
    apt autoremove -y

# install mecab
RUN apt-get install -y mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8

RUN ln -fns /usr/bin/python3.8 /usr/bin/python && \
    ln -fns /usr/bin/python3.8 /usr/bin/python3 && \
    ln -fns /usr/bin/pip3 /usr/bin/pip

ENV TZ Asia/Tokyo
ENV LANG ja_JP.UTF-8
RUN apt-get -y install language-pack-ja-base language-pack-ja

RUN pip install --upgrade pip && \
    pip install --upgrade setuptools

RUN python3 -m pip install --user numpy matplotlib pandas plotly scikit-learn scipy tqdm mecab-python3 unidic
RUN python3 -m unidic download
# mecab `dicdir` is in /var/lib/mecab/dic/, but unidic is installed in /root/.local/lib/python3.8/site-packages/unidic
# as the other dictionaries (debian, ipadic), make a symbolic link of unidic
# after that, we can run `mecab -d /var/lib/mecab/dic/unidic` as the other dictionaries
RUN ln -s /root/.local/lib/python3.8/site-packages/unidic/dicdir /var/lib/mecab/dic/unidic

WORKDIR /work
COPY src/ /work/src/
COPY data/ /work/data/
COPY scripts/ /work/scripts
