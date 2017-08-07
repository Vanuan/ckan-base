FROM python:2.7-slim
# FROM python:2.7-alpine - SIGSEGV

RUN apt-get -q -y update && apt-get -q -y upgrade && \
        DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
	python-dev \
        python-pip \
        python-virtualenv \
        libpq-dev \
        git-core \
        postgresql-client \
        libxml2-dev \
        libxslt-dev \
        libgeos-dev \
	&& apt-get -q clean

#RUN apk add --update --no-cache postgresql-dev \
#        postgresql-client \
#        libxml2-dev \
#        libxslt-dev \
#        build-base \
#        git
#RUN apk add --update --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
#        geos-dev
#

# Define environment variables
ENV CKAN_HOME /usr/lib/ckan
ENV CKAN_VENV $CKAN_HOME/venv
ENV CKAN_CONFIG /etc/ckan
ENV CKAN_STORAGE_PATH=/var/lib/ckan

# Build-time variables specified by docker-compose.yml / .env
ARG CKAN_SITE_URL

# Create ckan user
#RUN adduser -S -u 900 -h $CKAN_HOME -s /bin/false ckan

# Setup virtual environment for CKAN
RUN mkdir -p $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH

# Setup CKAN
RUN git clone https://github.com/ckan/ckan.git --depth 1 -b ckan-2.6.2 $CKAN_VENV/src/ckan/

RUN pip install --upgrade -r $CKAN_VENV/src/ckan/requirements.txt && \
    pip install -e $CKAN_VENV/src/ckan/ && \
    ln -s $CKAN_VENV/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini

#    cp -v $CKAN_VENV/src/ckan/contrib/docker/ckan-entrypoint.sh /ckan-entrypoint.sh && \
#    chmod +x /ckan-entrypoint.sh && \
#    chown -R ckan:ckan $CKAN_HOME $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH

ADD ckan-entrypoint.sh /
ENTRYPOINT ["/ckan-entrypoint.sh"]

EXPOSE 5000

CMD ["paster","serve","/etc/ckan/ckan.ini"]

