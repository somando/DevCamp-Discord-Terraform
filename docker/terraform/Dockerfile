FROM hashicorp/terraform

RUN apk update
RUN apk add --no-cache bash direnv

COPY docker/terraform/.bashrc /root/.bashrc

ENTRYPOINT ["/bin/bash"]
