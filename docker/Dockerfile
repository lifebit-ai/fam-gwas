# Base Image
FROM r-base:3.5.2

# Metadata
LABEL description="Docker image containing all dependencies for family-based GWAS pipeline: https://github.com/lifebit-ai/famgwas"

# Maintainer
LABEL Phil Palmer <phil@lifebit.ai>

# Install plink
RUN wget http://s3.amazonaws.com/plink1-assets/dev/plink_linux_x86_64.zip && \
    unzip *.zip && \
    mv plink /usr/local/bin/

# Install R dependencies
RUN Rscript -e "install.packages('qqman')"

RUN mkdir /data && \
    mkdir /data/scripts/

COPY ./R/ /data/scripts/

RUN chmod -R u+x /data/scripts

ENV PATH=$PATH:/data/scripts/

WORKDIR /data/scripts/
