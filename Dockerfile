FROM alpine:latest

# Alpine ships busybox applets for most of these. The later stages teach flags
# and output formats the busybox versions do not all match — stat -c, ps, and
# GNU grep/find in particular — so install the real ones.
#
# psmisc provides pstree (Stage 12). python3 runs the demos in Stages 11-15,
# which show fork, exec, race conditions, deadlock and page faults happening
# rather than describing them. There is deliberately no compiler: every demo is
# written in Python so the image stays small.
RUN apk add --no-cache \
        bash \
        coreutils \
        findutils \
        grep \
        less \
        ncurses \
        procps \
        psmisc \
        python3 \
        sed \
        shadow \
        tar

WORKDIR /app

COPY . .

RUN find . -name '*.sh' -exec chmod +x {} +

ENTRYPOINT ["/bin/bash", "./start.sh"]
