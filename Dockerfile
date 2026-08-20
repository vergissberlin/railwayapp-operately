ARG VERSION=1.8.0

FROM operately/operately:${VERSION}

LABEL maintainer="VergissBerlin"
LABEL description="Operately Template for Railway"

# SiteEncrypt (Operately's built-in cert manager) chmods CERT_DB_DIR directly at boot,
# even with no real domain configured (CERT_DOMAIN=""). It has to be a folder the
# `nobody` user already owns, so it can't just be /tmp.
USER root
RUN mkdir -p /media/certs && chown -R nobody:root /media/certs
USER nobody

# Railway ignores EXPOSE and routes traffic to the port named by $PORT.
# EXPOSE documents the local default, ENV PORT keeps that default reproducible.
ENV PORT=4000
EXPOSE 4000
