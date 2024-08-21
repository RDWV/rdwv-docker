FROM rdwv/rdwv-admin:original

USER root
COPY plugins/admin modules
COPY scripts/install-ui-plugins.sh /usr/local/bin/
RUN install-ui-plugins.sh
USER node
LABEL org.rdwv.plugins=true
