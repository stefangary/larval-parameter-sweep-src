# Use official Ubuntu 16.04 as base image

FROM ubuntu:xenial

# Set the working directory to /app

WORKDIR /app
ADD ./install_netCDF4.sh .
ADD ./test.sh .
ADD ./ariane-2.2.8_05_larval.tar.gz .
#ADD ./tcdf.tar.gz .  # see below - this is pulled directly from GitHub

RUN pwd
RUN ls -l
RUN ./test.sh

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y wget


RUN apt-get install -y apt-utils
RUN apt-get install -y git-core
# RUN apt-get install -y gcc

RUN apt-get install -y gfortran

CMD ["gcc", "--version"]
CMD ["gfortran", "--version"]

# sfg - I don't think we need python
# sfg - for ARIANE or postprocessing.
# RUN apt-get install -y python2.7
# RUN apt-get install -y python-pip

RUN apt-get install -y software-properties-common
# sfg - See note about python above.
# RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
# sfg - See note about python above.
# RUN apt-get install -y python3.6
# RUN apt-get install -y python3-pip

RUN ./install_netCDF4.sh 

# No need to explicitly decompress tarballs
# they are decompressed automatically with
# the ADD command above.
#RUN tar -xzf ariane-2.2.8_04_sfg.tar.gz
RUN cd ariane-2.2.8_05_larval; ./configure --prefix=/usr; make; make install; cd ../

# Install tcdf visualization tools
RUN git clone https://github.com/stefangary/tcdf.git
RUN cd tcdf/src; ./set_tcdf_prefix.sh /usr; make tcdf; make install; cd ../../

CMD ["echo", "Hello from Docker!"]
