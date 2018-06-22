FROM perl

# docker build -t vanessa/mpileup .

RUN apt-get update && \
     wget https://github.com/samtools/htslib/releases/download/1.3.2/htslib-1.3.2.tar.bz2 -O htslib.tar.bz2 && \
     tar -xjvf htslib.tar.bz2 && \
     cd htslib-1.3.2 && make && make install

RUN apt-get -y install wget libbz2-dev zlib1g-dev xz-utils liblzma-dev && \
    apt-get -y install libncurses5-dev unzip && \
    wget https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2 && \
    tar xvjf samtools-1.6.tar.bz2 && \
    cd samtools-1.6 && \
    ./configure --without-curses --prefix=/usr/local && make && make install

RUN mkdir -p /code

# We have to add /code to the perl @inc so the library is found
ENV PERLLIB /code
WORKDIR /code
ADD . /code

RUN wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr2.fa.gz && \
    gunzip chr2.fa.gz && \
    chmod u+x Query_Editing_Level.GRCh37.20161110.pl

ENTRYPOINT ["perl","/code/Query_Editing_Level.GRCh37.20161110.pl"]
