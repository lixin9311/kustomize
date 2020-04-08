FROM alpine
LABEL maintainer="lucas.li@linktivity.co.jp"
RUN apk --no-cache add ca-certificates wget && update-ca-certificates
RUN wget -O /usr/local/bin/kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v2.0.3/kustomize_2.0.3_linux_amd64
ENTRYPOINT ["/bin/sh", "-c"]
