FROM alpine:latest

# Alpine ships busybox applets for most of these. The later stages teach flags
# and output formats the busybox versions do not all match — stat -c, ps, and
# GNU grep/find in particular — so install the real ones.
RUN apk add --no-cache \
        bash \
        coreutils \
        findutils \
        grep \
        less \
        ncurses \
        procps \
        sed \
        shadow

WORKDIR /app

COPY . .

RUN find . -name '*.sh' -exec chmod +x {} +

ENTRYPOINT ["/bin/bash", "./start.sh"]
