[![Build Stratum dependencies](https://github.com/ipdk-io/stratum-deps/actions/workflows/build-deps.yml/badge.svg)](https://github.com/ipdk-io/stratum-deps/actions/workflows/build-deps.yml)

# Stratum Dependencies

Stratum is the component of `infrap4d` that implements the P4Runtime and gNMI
(OpenConfig) services.

This repository allows you to build and install various third-party libraries
required by Stratum.

It is intended to supersede the `setup` directory in `networking-recipe`.

The repository is functional, but it is still a work in progress.

## Build instructions

- [Building Host Dependencies](/docs/building-host-deps.md)
- [Building ACC Target Dependencies](/docs/building-acc-target-deps.md)
- [Defining the ACC Build Environment](docs/defining-acc-environment.md)

## Utilities

- [make-cross-deps.sh](/docs/make-cross-deps.rst)
- [make-host-deps.sh](/docs/make-host-deps.rst)

## Other documents

- [Change History](/docs/change-history.md)
