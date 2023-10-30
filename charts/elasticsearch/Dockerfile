FROM --platform=$TARGETPLATFORM registry.woqutech.com/google_containers/alpine:3.13
RUN apk add curl bash jq

COPY config-es.sh /config-es.sh
ADD log-templates /log-templates
RUN chmod +x /config-es.sh
