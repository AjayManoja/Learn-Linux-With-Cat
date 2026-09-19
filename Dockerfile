FROM alpine:latest

RUN apk add --no-cache bash ncurses coreutils

WORKDIR /app

COPY . .

RUN chmod +x start.sh reset.sh check.sh

ENTRYPOINT ["/bin/bash", "./start.sh"]
