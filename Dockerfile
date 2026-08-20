ARG VERSION=1.8.0

FROM operately/operately:${VERSION}

LABEL maintainer="VergissBerlin"
LABEL description="Operately Template for Railway"

# Railway ignores EXPOSE and routes traffic to the port named by $PORT.
# EXPOSE documents the local default, ENV PORT keeps that default reproducible.
ENV PORT=4000
EXPOSE 4000
