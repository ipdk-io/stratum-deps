.. Copyright 2023 Intel Corporation
   SPDX-License-Identifier: Apache 2.0

=================
Component History
=================

Upgraded in v3.1.1
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

Upgraded in v3.1.0
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
