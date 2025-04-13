# Download and verify the RPM in this container
FROM public.ecr.aws/amazonlinux/amazonlinux:2023


RUN rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO && \
    curl -s https://mirror.go-repo.io/centos/go-repo.repo | tee > /etc/yum.repos.d/go-repo.repo

# Install libraries
RUN yum upgrade -y &&  \
    yum install -y \
    sudo \
    wget \
    unzip \
    make \
    git \
    golang

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
ENV AWS_REGION="ap-northeast"

RUN git config --global credential.UseHttpPath true && \
    git config --global credential.helper '!aws --profile mlops codecommit credential-helper $@' && \
    git clone https://git-codecommit.ap-northeast-2.amazonaws.com/v1/repos/goofys && \
    cd goofys && \
    make build && \
    mv goofys /opt