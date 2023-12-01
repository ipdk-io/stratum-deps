This page documents the dependencies library upgrade history  in `stratum-deps`.

.. list-table::
   :header-rows: 1

   * - Library upgraded
     - From
     - To
     - CVEs addressed
     - PR link
     - Note
   * - gRPC
     - 1.54.2
     - 1.59.2
     - `CVE-2023-33953 <https://nvd.nist.gov/vuln/detail/CVE-2023-33953>`_
       `CVE-2023-4785 <https://nvd.nist.gov/vuln/detail/CVE-2023-4785>`_
     - `PR #41 <https://github.com/ipdk-io/stratum-deps/pull/41>`_
     - 
   * - Protobuf
     - 3.20.2
     - 25.0
     -
     - `PR #41 <https://github.com/ipdk-io/stratum-deps/pull/41>`_
     - 
   * - abseil-cpp
     - 20220623.0
     - 20230802.0
     -
     - `PR #41 <https://github.com/ipdk-io/stratum-deps/pull/41>`_
     - 
   * - zlib
     - 1.2.13
     - 1.3
     - `CVE-2023-45853 <https://nvd.nist.gov/vuln/detail/CVE-2023-45853>`_
     - `PR #45 <https://github.com/ipdk-io/stratum-deps/pull/45>`_
     - CVE is still present in zlib 1.3 as part of MiniZip experimental code
       (unused feature in ipdk-io/networking-recipe) and not part of official
       zlib release yet

