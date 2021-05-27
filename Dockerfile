FROM ubuntu:20.04
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade
RUN apt-get install -y curl gnupg wget unzip git
RUN apt-get install -y build-essential 
RUN wget https://releases.hashicorp.com/terraform/0.15.1/terraform_0.15.1_linux_arm64.zip
RUN unzip terraform_0.15.1_linux_arm64.zip
RUN mv terraform /usr/local/bin
ENV HOME /root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y awscli
# kubect
RUN curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.15/2020-11-02/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && \
  cp ./kubectl /usr/local/bin/kubectl
# eks
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
  mv /tmp/eksctl /usr/local/bin && \
  eksctl version
# helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh && \
  chmod 700 get_helm.sh && \
  ./get_helm.sh

WORKDIR /root
CMD [ "/bin/bash" ]
