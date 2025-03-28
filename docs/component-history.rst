.. Copyright 2023-2025 Intel Corporation
   SPDX-License-Identifier: Apache 2.0

=================
Component History
=================

Upgraded in v1.4.0
------------------

.. list-table::
   :header-rows: 1

   * - Component
     - From
     - To
     - CVEs Addressed
     - PR

   * - abseil-cpp
     - 20230802.0
     - 20240722.0
     -
     - `91 <https://github.com/ipdk-io/stratum-deps/pull/91>`_

   * - grpc
     - 1.59.2
     - 1.69.0
     - 
     - `91 <https://github.com/ipdk-io/stratum-deps/pull/91>`_

   * - protobuf
     - 25.0
     - 29.0
     - `CVE-2024-7254 <https://nvd.nist.gov/vuln/detail/cve-2024-7254>`_
     - `91 <https://github.com/ipdk-io/stratum-deps/pull/91>`_

   * - zlib
     - 1.3
     - 1.3.1
     - `CVE-2023-45853 <https://nvd.nist.gov/vuln/detail/CVE-2023-45853>`_
     - `94 <https://github.com/ipdk-io/stratum-deps/pull/94>`_

Upgraded in v1.3.5
------------------

.. list-table::
   :header-rows: 1

   * - Component
     - From
     - To
     - CVEs Addressed
     - PR

   * - c-ares
     - 1.19.1
     - 1.34.4
     - `CVE-2024-25629 <https://nvd.nist.gov/vuln/detail/CVE-2024-25629>`_
     - `86 <https://github.com/ipdk-io/stratum-deps/pull/86>`_

Changes and Upgrades in v1.3.4
------------------------------

.. list-table::
   :header-rows: 1

   * - Component
     - From
     - To
     - Issues addressed
     - PR

   * - re2
     - 2022-04-01
     - 2022-12-01
     - Updated to release that installs a pkg-config file
     - `74 <https://github.com/ipdk-io/stratum-deps/pull/74>`_

.. list-table::
   :header-rows: 1

   * - Component
     - Change
     - PR

   * - re2
     - Made RE2 is discrete component
     - `73 <https://github.com/ipdk-io/stratum-deps/pull/73>`_


Upgraded in v1.3.1
------------------

.. list-table::
   :header-rows: 1

   * - Component
     - From
     - To
     - CVEs Addressed
     - PR

   * - zlib
     - 1.2.13
     - 1.3
     - `CVE-2023-45853 <https://nvd.nist.gov/vuln/detail/CVE-2023-45853>`_
     - `45 <https://github.com/ipdk-io/stratum-deps/pull/45>`_

CVE is still present in zlib 1.3 as part of the MiniZip experimental code,
but it is not used.

Upgraded in v1.3.0
------------------

.. list-table::
   :header-rows: 1

   * - Component
     - From
     - To
     - CVEs Addressed
     - PR

   * - abseil-cpp
     - 20220623.0
     - 20230802.0
     -
     - `41 <https://github.com/ipdk-io/stratum-deps/pull/41>`_

   * - grpc
     - 1.54.2
     - 1.59.2
     - `CVE-2023-33953 <https://nvd.nist.gov/vuln/detail/CVE-2023-33953>`_

       `CVE-2023-4785 <https://nvd.nist.gov/vuln/detail/CVE-2023-4785>`_
     - `41 <https://github.com/ipdk-io/stratum-deps/pull/41>`_

   * - protobuf
     - 3.20.2
     - 25.0
     -
     - `41 <https://github.com/ipdk-io/stratum-deps/pull/41>`_
