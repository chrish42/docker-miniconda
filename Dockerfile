FROM debian:wheezy
MAINTAINER Christian Hudon <chrish@pianocktail.org>

ENV LANG C.UTF-8
ENV PATH /opt/anaconda/bin:$PATH
ENV MINICONDA_VERSION 3.7.0

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y bzip2 curl && rm -rf /var/lib/apt/lists/*
RUN curl -o /tmp/miniconda.sh http://repo.continuum.io/miniconda/Miniconda-$MINICONDA_VERSION-Linux-x86_64.sh && bash /tmp/miniconda.sh -b -p /opt/anaconda && rm /tmp/miniconda.sh

RUN useradd -mU user
USER user

ONBUILD USER root
ONBUILD RUN useradd --system --user-group --home-dir /app app
ONBUILD RUN mkdir /app
ONBUILD WORKDIR /app
ONBUILD COPY conda_requirements.txt requirements.txt /app/
ONBUILD RUN conda create -p /env --yes --file /app/conda_requirements.txt pip
ONBUILD ENV PATH /env/bin:$PATH
ONBUILD RUN pip install -r /app/requirements.txt
ONBUILD USER app

ENTRYPOINT ["python"]
