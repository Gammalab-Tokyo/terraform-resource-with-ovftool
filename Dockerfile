FROM ubuntu:focal

RUN apt update \
 && apt upgrade -y \
 && apt install -y ca-certificates git bash openssh-client curl gpg wget \
 && wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor | \
        tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com focal main" | \
        tee /etc/apt/sources.list.d/hashicorp.list \
 && apt update \
 && apt install -y terraform

RUN mkdir -p $HOME/.ssh
RUN echo "StrictHostKeyChecking no" >> $HOME/.ssh/config
RUN echo "LogLevel quiet" >> $HOME/.ssh/config
RUN chmod 0600 $HOME/.ssh/config

RUN mkdir -p /usr/local/share/terraform/plugins/github.com/ashald/stateful/1.2.0/linux_amd64/ && \
    wget -O /usr/local/share/terraform/plugins/github.com/ashald/stateful/1.2.0/linux_amd64/terraform-provider-stateful_v1.2.0 \
    "https://github.com/ashald/terraform-provider-stateful/releases/download/v1.2.0/terraform-provider-stateful_v1.2.0-linux-amd64" && \
    chmod +x /usr/local/share/terraform/plugins/github.com/ashald/stateful/1.2.0/linux_amd64/terraform-provider-stateful_v1.2.0

RUN terraform --version
COPY out/check out/in out/out /opt/resource/
