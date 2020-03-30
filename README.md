# easy-ca
OpenSSL wrapper scripts for managing basic CA functions

[![Test CI Status](https://travis-ci.org/cgzones/easy-ca.svg?branch=develop)](https://travis-ci.org/cgzones/easy-ca)
[![GitHub License](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://raw.githubusercontent.com/cgzones/easy-ca/master/LICENSE)

A suite of bash scripts for automating very basic OpenSSL Certificate Authority operations:
* Creating Root CAs
* Creating Intermediate Signing CAs
* Creating Server certificates
* Creating Client certificates
* Revoking certificates and maintaining CRLs

## Usage

### tl;dr

#### Scripts:

| Name              | Description                                                       |
| ----------------- | ----------------------------------------------------------------- |
| create-client     | Create a client certificate                                       |
| create-root-ca    | Create a root signing CA                                          |
| create-server     | Create a server certificate                                       |
| create-signing-ca | Create an intermediate signing CA inside a root CA                |
| gen-html          | Create a shareable html directory structure for publishing the CA |
| revoke-cert       | Revoke a (client\|server) certificate                             |
| show-status       | Show the infos about the current CA (signed certificates...)      |
| sign-csr          | Sign an imported client certificate                               |

#### Important files:

| Path                    | Description                              |
| ----------------------- | ---------------------------------------- |
| bin/                    | Script directory                         |
| ca/ca.crt               | CA certificate                           |
| ca/chain.pem            | CA chain certificate                     |
| certs/(client\|server)/ | Parent directory for signed certificates |

### Create a new Root CA

The **create-root-ca** script will initialize a new Root CA directory structure. This script can be run directly from the source repo or from within an existing Easy CA installation. The CA is self-contained within the specified directory tree. It is portable and can be stored on removable media for security.

```
create-root-ca -d $ROOT_CA_DIR
```

**create-root-ca** will prompt for the basic DN configuration to use as defaults for this CA. Optionally, you can edit *defaults.conf* to set this information in advance. The new CA is now ready for use. The CA certificate, key and CRL are available for review:

```
$ROOT_CA_DIR/ca/ca.crt
$ROOT_CA_DIR/ca/private/ca.key
$ROOT_CA_DIR/ca/ca.crl
```

### (Optional) Create an Intermediate Signing CA

Running **create-signing-ca** from within a Root CA installation will initialize a new Intermediate CA directory structure, independent and separate from the Root CA. A Root CA may issue multiple Intermediate CAs.

```
$ROOT_CA_DIR/bin/create-signing-ca -d $SIGNING_CA_DIR
```

**create-signing-ca** will prompt for basic DN configuration, using the Root CA configuration as defaults. The Intermediate Signing CA is now ready for use. The CA key, certificate, chain file, and CRL are available for review as well as the root certificate and the chain bundle:

```
$SIGNING_CA_DIR/ca/ca.crt
$SIGNING_CA_DIR/ca/private/ca.key
$SIGNING_CA_DIR/ca/ca.crl
$SIGNING_CA_DIR/ca/root.crt
$SIGNING_CA_DIR/ca/chain.pem
```

### Issue a Server Certificate

Running **create-server** from within any CA installation will issue a new server (serverAuth) certificate:

```
$CA_DIR/bin/create-server -s "FQDN Description" -a fqdn.domain.com -a www.fqdn.domain.com
```

All addresses **must** be supplied via the *-a* flag.

**create-server** will prompt for basic DN configuration, using the CA configuration as defaults. After the script is completed, the server certificate, key, and CSR are available for review in the directory *$CA_DIR/certs/server/FQDN-Description/*:

```
$CA_DIR/certs/server/FQDN-Description/FQDN-Description.crt
$CA_DIR/certs/server/FQDN-Description/FQDN-Description.key
$CA_DIR/certs/server/FQDN-Description/FQDN-Description.csr
```

### Issue a Client Certificate

Running **create-client** from within any CA installation will issue a new client (clientAuth) certificate:

```
$CA_DIR/bin/create-client -c user@domain.com
```

**create-client** will prompt for basic DN configuration, using the CA configuration as defaults. After the script is completed, the client certificate, key, and CSR are available for review in the directory *$CA_DIR/certs/clients/user-domain-com/*:

```
$CA_DIR/certs/clients/user-domain-com/user-domain-com.crt
$CA_DIR/certs/clients/user-domain-com/user-domain-com.key
$CA_DIR/certs/clients/user-domain-com/user-domain-com.csr
```

### Revoke a Certificate

Running **revoke-cert** from within a CA installation allows you to revoke a certificate issued by that CA and update the CRL:

```
$CA_DIR/bin/revoke-cert -c $CA_DIR/certs/server/FQDN-Description/FQDN-Description.crt
```

**revoke-cert** will prompt for the revocation reason. After the script is completed, the server CRL is updated and available for review:

```
$CA_DIR/ca/ca.crl
```

## Caveats

These scripts are very simple, and make some hard-coded assumptions about behavior and configuration:
* Root and Intermediate CAs have a 3652-day lifetime (configurable in *templates/(root|signing).tpl*)
* Root and Intermediate CAs have 4096-bit RSA keys (configurable in *defaults.conf*)
* Root and Intermediate CA keys are always encrypted
* Only one level of Intermediate CA is supported
* Client and Server certificates have a 730-day lifetime (configurable in *templates/(server|client).tpl*)
* Client and Server certificates have 3072-bit RSA keys (configurable in *defaults.conf*)
* Client and Server keys are not encrypted
* There is no wrapper *yet* for renewing certificates

## License

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
