FROM alexnicoll/go-build-env

RUN apt-get update && apt-get install --yes vim

RUN go install golang.org/x/tools/gopls@v0.11.0

# /root/host must be mapped to a volume at run time.
# Clear the Go build and module caches. Their locations are about to change.
RUN ["rm", "-r", "/root/.cache/go-build", "/go/pkg/mod"]
# Remove .cache if it is now empty.
RUN /bin/bash -c 'rm -d /root/.cache || true'
# Store the Go build cache and module cache in /root/host
RUN ["go", "env", "-w", "GOCACHE=/root/host/.go-cache/build", "GOMODCACHE=/root/host/.go-cache/mod"]
