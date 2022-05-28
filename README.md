Custom base container for running [Nix](https://nixos.org/nix/) inside [Act](https://github.com/nektos/act). Act is awesome. It lets you run Github Actions locally (in docker), so you can fix bugs in your CI without pushing and waiting for Github to churn through the actions.

All you need is the `Dockerfile` from this repo, but there is also a demo `ci.yml` so you can verify thta it works. So build the image locally:

```
docker build -t dsyer/ubuntu:act-latest .
```

and then run it:

```
act -P ubuntu-latest=dsyer/ubuntu:act-latest -s GITHUB_TOKEN=...
```

Note that the step in `ci.yml` that needs to use `Nix` tools has to `. ~/.profile` (in Github it doesn't need that, but it's harmless):

```
name: CI

on:
  push:
    branches:
    - '**'
    - '!dependabot/**'
  pull_request: {}

jobs:

  fats:
    name: test
    runs-on: ubuntu-latest
    env:
      DOCKER_BUILDKIT: 1
    steps:
    - uses: actions/checkout@v2
    - uses: cachix/install-nix-action@v13
      with:
        nix_path: nixpkgs=channel:nixos-unstable
    - name: Setup env
      run: |
        . ~/.profile # not usually necessary
        id="job-$(date +%s)"
        echo "JOB_ID=${id}" >> $GITHUB_ENV
        echo "CLUSTER_NAME=cli-${id}" >> $GITHUB_ENV
        echo "NAMESPACE=cli-${id}" >> $GITHUB_ENV
        nix-env -i -f default.nix
        docker ps
      shell: bash
```
