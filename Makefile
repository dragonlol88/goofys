export CGO_ENABLED=0

run-test: s3proxy.jar
	./test/run-tests.sh

s3proxy.jar:
	wget https://github.com/gaul/s3proxy/releases/download/s3proxy-1.8.0/s3proxy -O s3proxy.jar

get-deps: s3proxy.jar
	go get -t ./...

build:
	go build -ldflags "-X main.Version=`git rev-parse HEAD`"

install:
	go install -ldflags "-X main.Version=`git rev-parse HEAD`"

docker-build:
    docker build --build-arg AWS_ACCESS_KEY_ID=${aws_access_key} --build-arg AWS_SECRET_ACCESS_KEY=${aws_secret_access_key} -t goofysimage:lastest .






