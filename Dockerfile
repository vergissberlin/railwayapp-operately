ARG VERSION=1.10.0

FROM operately/operately:${VERSION}

LABEL maintainer="VergissBerlin"
LABEL description="Operately Template for Railway"

# SiteEncrypt (Operately's built-in cert manager) mkdir_p's and chmods CERT_DB_DIR
# directly at boot, even with no real domain configured (CERT_DOMAIN=""). It has to
# be a folder the `nobody` user owns that isn't shadowed by the /media volume mount
# (Railway mounts the volume over /media at container start, after the image is
# built, so anything created under /media at build time is gone by boot time).
USER root
RUN mkdir -p /opt/operately/certs && chown -R nobody:root /opt/operately/certs
COPY predeploy.sh /opt/operately/bin/predeploy.sh
RUN chmod +x /opt/operately/bin/predeploy.sh
USER nobody

# Operately's cert child reads CERT_* at every boot, even with CERT_AUTO_RENEW unset (manual
# mode): an unset CERT_DOMAIN/CERT_DB_DIR crashes it, while empty strings are the official
# installer's "no TLS" path. Baking them in means Railway deploys need no CERT_* variables;
# any value set on the service still overrides these.
ENV CERT_DOMAIN="" \
    CERT_EMAILS="" \
    CERT_DB_DIR=/opt/operately/certs

# Railway ignores EXPOSE and routes traffic to the port named by $PORT.
# EXPOSE documents the local default, ENV PORT keeps that default reproducible.
ENV PORT=4000
EXPOSE 4000
