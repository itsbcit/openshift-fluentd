FROM fluent/fluentd:v0.12

LABEL maintainer="chriswood.ca@gmail.com"

ENV RUNUSER fluent
ENV HOME /home/fluent

RUN apk add --no-cache --update --virtual .build-deps \
    build-base ruby-dev git

# Standalone Fluentd section
# http://v1.uncontained.io/playbooks/operationalizing/secure-forward-splunk.html
# record modifier added to deal with
# error_class=Encoding::UndefinedConversionError error="\"\\xE2\" from ASCII-8BIT to UTF-8"
RUN /usr/bin/fluent-gem install \
        fluent-plugin-secure-forward \
        fluent-plugin-record-modifier:0.6.2 \
        fluent-plugin-rewrite-tag-filter:1.6.0

# RUN /usr/bin/gem install \
#         fluent-plugin-splunk-ex
#download source to fix gemspec for ruby compatiblity
WORKDIR /src/fluent-plugin-splunk-ex
RUN git clone https://github.com/gtrevg/fluent-plugin-splunk-ex.git . && \
        sed -i 's/0.10.17/0.12.43/' fluent-plugin-splunk-ex.gemspec && \
        gem build fluent-plugin-splunk-ex.gemspec && \
        gem install fluent-plugin-splunk-ex-1.0.1.gem

RUN gem list && \
        gem sources --clear-all && \
        apk del .build-deps && \
        rm -rf /src/fluent-plugin-splunk-ex

WORKDIR /
# Add docker-entrypoint script base
ENV DE_VERSION v1.3
ADD https://github.com/itsbcit/docker-entrypoint/releases/download/${DE_VERSION}/docker-entrypoint.tar.gz /docker-entrypoint.tar.gz
RUN tar zxvf docker-entrypoint.tar.gz && rm -f docker-entrypoint.tar.gz
RUN chmod -R 555 /docker-entrypoint.*

# Allow resolve-userid.sh script to run
RUN chmod 664 /etc/passwd /etc/group

RUN mkdir /fluentd/certs && \
        chown -R root:root /fluentd && \
        chmod 775 /fluentd /fluentd/log /fluentd/certs

VOLUME /fluentd/log

RUN rm /bin/entrypoint.sh

USER fluent
EXPOSE 24284

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["fluentd", "-c", "/fluentd/etc/fluent.conf"]
