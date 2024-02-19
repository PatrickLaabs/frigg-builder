FROM alpine:latest

RUN apk --no-cache add \
  bash \
  coreutils \
  curl \
  openssh \
  openssl \
  libressl \
  python3 \
  py3-pip \
  sed \
  jq \
  util-linux \
  git \
  && rm -rf /var/cache/apk/*

#RUN pip3 install pyyaml semver --upgrade 

# DESIRED_VERSION is the helm version to install
ENV DESIRED_VERSION v3.5.0
RUN mkdir -p $HOME/.helm && export HELM_HOME="$HOME/.helm" && curl -L https://git.io/get_helm.sh | /bin/bash

# GET KUBECTL
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

# GET ARGOCD CLI
RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v2.9.3/argocd-linux-amd64
RUN chmod +x argocd-linux-amd64
RUN mv ./argocd-linux-amd64 /usr/local/bin/argocd

# GET CLUSTERCTL CLI
RUN curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.6.1/clusterctl-linux-amd64 -o clusterctl
RUN chmod +x clusterctl
RUN mv ./clusterctl /usr/local/bin/clusterctl

# GET GITHUB CLI
RUN curl -L -o gh-cli.tar.gz https://github.com/cli/cli/releases/download/v2.42.1/gh_2.42.1_linux_amd64.tar.gz
RUN tar -xf gh-cli.tar.gz && mv ./gh_2.42.1_linux_amd64/bin/gh /usr/local/bin/gh
RUN chmod +x /usr/local/bin/gh
RUN rm gh-cli.tar.gz && rm -rf ./gh_2.42.1_linux_amd64

# ADD SSH KEY FINGERPRINTS
RUN mkdir -p ~/.ssh
RUN cat <<EOF >> ~/.ssh/known_hosts
github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
EOF
RUN chmod 700 ~/.ssh && \
    chmod 644 ~/.ssh/known_hosts

CMD [ "/bin/bash" ]
