# PCD Plataforma Clusterizada

This repository contains Kubernetes manifests and helper scripts for a clustered platform.

## Local checks

### Validate Kubernetes manifests

Use [kubeval](https://github.com/instrumenta/kubeval) to verify that manifests in the `k8s/` directory are valid:

```bash
kubeval k8s/*.yaml
```

### Lint shell scripts

Use [ShellCheck](https://www.shellcheck.net/) to lint `init-structure.sh`:

```bash
shellcheck init-structure.sh
```

## GitHub Actions

Continuous integration is configured in `.github/workflows/ci.yml` and automatically runs the above checks on every push and pull request.
