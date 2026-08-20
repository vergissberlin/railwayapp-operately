ARG VERSION=1.8.0

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

# Railway ignores EXPOSE and routes traffic to the port named by $PORT.
# EXPOSE documents the local default, ENV PORT keeps that default reproducible.
ENV PORT=4000
EXPOSE 4000
