<!-- markdownlint-disable MD041 -->
[![Build Stratum dependencies](https://github.com/ipdk-io/stratum-deps/actions/workflows/build-deps.yml/badge.svg)](https://github.com/ipdk-io/stratum-deps/actions/workflows/build-deps.yml)
<!-- markdownlint-disable MD041 -->

# Stratum Dependencies

Stratum is the component of `infrap4d` that implements the P4Runtime and gNMI
(OpenConfig) services.

This repository allows you to build and install various third-party libraries
required by Stratum.

We plan to phase out the
[networking-recipe/setup](https://github.com/ipdk-io/networking-recipe/tree/main/setup)
directory in favor of this repository around the end of October 2023.

If you would like to start using `stratum-deps` before then,
[version 1.2.1](https://github.com/ipdk-io/stratum-deps/tree/v1.2.1) is a
good place to start.

See the [Transition Guide](/docs/transition-guide.md) for more information.

## Build instructions

- [Building Host Dependencies](/docs/building-host-deps.md)
- [Building ACC Target Dependencies](/docs/building-acc-target-deps.md)
- [Defining the ACC Build Environment](docs/defining-acc-environment.md)

## Utilities

- [make-cross-deps.sh](/docs/make-cross-deps.rst)
- [make-host-deps.sh](/docs/make-host-deps.rst)
