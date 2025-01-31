FROM python:3.10-alpine3.17

COPY . /bin/

    # Give execution permission to deploy script
RUN chmod +x /bin/deploy.sh \ 
    && chmod +x /bin/version.sh \
    && chmod +x /bin/build.sh \
    # Install openssh-client, bash, helm, git, tar and kubectl
    && apk add --no-cache openssh-client bash gettext helm git tar curl \
    && curl -LO https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl \
    && chmod +x kubectl && mv ./kubectl /bin/kubectl

WORKDIR /tmp/project

ENTRYPOINT ["/bin/bash","-c"]