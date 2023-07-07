FROM debian:12

VOLUME "/input"
VOLUME "/output"
VOLUME "/storage"

RUN \
    apt-get update -q \
    && apt-get install -y git handbrake-cli \
    && rm -rf /var/lib/apt/lists/*

COPY transcode.sh /
RUN chmod +x /transcode.sh

ENTRYPOINT [ "bash", "/transcode.sh" ]