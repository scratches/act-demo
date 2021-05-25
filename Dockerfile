FROM catthehacker/ubuntu:act-latest

RUN mkdir -p /etc/nix && echo "build-users-group =" > /etc/nix/nix.conf && \
  curl -L https://nixos.org/nix/install | sh
