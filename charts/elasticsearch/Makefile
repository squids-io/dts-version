
VERSION ?= v0.3.1
IMAGE_NAME=registry.woqutech.com/woqutech/elasticsearch-config-job:$(VERSION)



build_all: build-amd64 build-arm64

push_all: push-amd64 push-arm64

build-amd64:
	docker buildx build --platform linux/amd64  -t  registry.woqutech.com/woqutech/elasticsearch-config-job:$(VERSION) .
push-amd64:
	docker push registry.woqutech.com/woqutech/elasticsearch-config-job:$(VERSION)

build-arm64:
	docker buildx build --platform linux/arm64  -t  registry.woqutech.com/woqutech/elasticsearch-config-job:$(VERSION)-arm .

push-arm64:
	docker push registry.woqutech.com/woqutech/elasticsearch-config-job:$(VERSION)-arm