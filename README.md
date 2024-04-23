<!-- markdownlint-disable MD041 -->
[![Build Stratum dependencies](https://github.com/ipdk-io/stratum-deps/actions/workflows/build-deps.yml/badge.svg)](https://github.com/ipdk-io/stratum-deps/actions/workflows/build-deps.yml)
<!-- markdownlint-enable MD041 -->

# Stratum Dependencies

Stratum is the component of `infrap4d` that implements the P4Runtime and gNMI
(OpenConfig) services.

This repository allows you to build and install various third-party libraries
required by Stratum.

## Project status

The `stratum-deps` repository replaces the
[networking-recipe/setup](https://github.com/ipdk-io/networking-recipe/tree/main/setup)
directory, which has been phased out.

See the [Releases](https://github.com/ipdk-io/stratum-deps/releases) page
for a list of releases, with their release notes and artifacts.
The most recent release is
[version 1.3.1](https://github.com/ipdk-io/stratum-deps/releases/tag/v1.3.1).

See the [Transition Guide](/docs/transition-guide.md) for more information.

## Build instructions

- [Building Host Dependencies](/docs/building-host-deps.md)
- [Building ACC Target Dependencies](/docs/building-acc-target-deps.md)
- [Defining the ACC Build Environment](docs/defining-acc-environment.md)

## Helper scripts

- [make-cross-deps.sh](/docs/make-cross-deps.rst)
- [make-host-deps.sh](/docs/make-host-deps.rst)
