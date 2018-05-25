FROM fluent/fluentd

ENV RUNUSER fluent
ENV HOME /home/fluent

# Add docker-entrypoint script base
ENV DE_VERSION v1.1
ADD https://github.com/itsbcit/docker-entrypoint/releases/download/${DE_VERSION}/docker-entrypoint.tar.gz /docker-entrypoint.tar.gz
RUN tar zxvf docker-entrypoint.tar.gz && rm -f docker-entrypoint.tar.gz
RUN chmod -R 555 /docker-entrypoint.*

# Allow resolve-userid.sh script to run
RUN chmod 664 /etc/passwd /etc/group

RUN chown -R root:root /fluentd \
 && chmod 775 /fluentd /fluentd/log

RUN rm /bin/entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD exec fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT
