![License](https://img.shields.io/badge/license-Apache%202-blue.svg)
# Nexus

#### Table of contents

1. [Overview](#overview)
2. [Supported Platforms](#supported-platforms)
3. [Requirements](#requirements)
4. [Installation](#installation)
5. [Usage](#usage)
6. [References](#references)
7. [Development](#development)

## Overview

This module will install the Nexus 3 (>= 3.1) in your system.

The default version is the 3.9.0-01.

This module can also configure SSL for Nexus.

## Supported Platforms

This module was tested under these platforms

- EL 7
- Debian 8 and 9

Tested only in X86_64 arch.  

## Requirements

- Puppet >= 5.3.3
- Hiera >= 3.4.2 (v5 format)

## Installation

Via git

    # cd /etc/puppetlabs/code/environment/production/modules
    # git clone https://github.com/instruct-br/puppet-nexus.git nexus

## Usage

### Quick run

    puppet apply -e "include nexus"

### Using with parameters

#### Example in EL 7 with no SSL

```
class { 'nexus':
  http_listen_address => '192.168.250.80',
  http_port           => 8080,
  major_version       => 3,
  minor_version       => 7,
  release_version     => 1,
  revision            => 02,
}
```

#### Example in EL 7 with SSL enabled

```
## first generate a certificate
## puppet cert generate nexus

java_ks { 'nexus_keystore_base':
  ensure       => latest,
  certificate  => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  target       => "${nexus::nexus_path}/etc/ssl/keystore.jks",
  password     => 'puppet',
  trustcacerts => true,
}

java_ks { 'nexus_keystore_certs':
  ensure              => latest,
  certificate         => '/etc/puppetlabs/puppet/ssl/certs/nexus.pem',
  private_key         => '/etc/puppetlabs/puppet/ssl/private_keys/nexus.pem',
  private_key_type    => 'rsa',
  target              => "${nexus::nexus_path}/etc/ssl/keystore.jks",
  password            => 'puppet',
  password_fail_reset => true,
}

class { 'nexus':
  enable_https            => true,
  listen_address          => '192.168.250.80',
  https_port              => 8081,
  https_keystore          => "${nexus::nexus_path}/etc/ssl/keystore.jks",
  https_keystore_password => 'puppet',
}
```

## References

### Classes

```
nexus
nexus::install (private)
nexus::config (private)
nexus::service (private)
```

### Parameters

#### `nexus_user`

Type: String

User that will execute Nexus and own its directories

#### `nexus_group`

Type: String

Group for Nexus user

#### `temp_path`

Type: String

Path where the file will be downloaded before extraction

#### `install_path`

Type: String

Path where Nexus will be extracted

#### `service_name`

Type: String

Name for Nexus's service

#### `service_provider`

Type: String

Service provider

#### `os_ext`

Type: String

Extension for filename that depends on OS

#### `major_version`

Type: String

Nexus's major version

#### `minor_version`

Type: String

Nexus's minor version

#### `release_version`

Type: String

Nexus's release version

#### `revision`

Type: String

Nexus's revision

#### `http_port`

Type: Integer

Port to serve HTTP

#### `https_port`

Type: Integer

Port to serve HTTPS

#### `listen_address`

Type: String

IP address Nexus listen (same for http and https)

#### `enable_https`

Type: Boolean

Whether to enable HTTPS or not

#### `https_keystore`

Type: String

Path to the keystore.jks

#### `https_keystore_password`

Type: String

Password to access the keystore

#### `java_xms`

Type: String

The JVM minimum heap size. Default to '512M'.

#### `java_xmx`

Type: String

The JVM maximum heap size. Default to '1200M'.

#### `java_max_direct_mem`

Type: String

The JVM maximum direct memory size. Default to '2G'.

#### `manage_java`

Type: Boolean

Whether this module will manage Java or not

#### `java_distribution`

Type: String

Java's desired distribution

### Hiera Keys

#### Common

```yaml
---
nexus::nexus_user: 'nexus'
nexus::nexus_group: 'nexus'
nexus::service_name: 'nexus3'

nexus::major_version: '9'
nexus::minor_version: '0'
nexus::revision: '01'


nexus::http_port: 8081
nexus::listen_address: '0.0.0.0'
nexus::enable_https: true
nexus::https_port: 8082
```

#### OS' Family Keys
```
---
nexus::temp_path
nexus::install_path
nexus::service_provider
nexus::os_ext
```

### Hiera module config

This is the Hiera v5 configuration inside the module.

This module does not have params class, everything is under hiera v5.

```
---
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "OSes"
    paths:
     - "oses/distro/%{facts.os.name}/%{facts.os.release.major}.yaml"
     - "oses/family/%{facts.os.family}.yaml"

  - name: "common"
    path: "common.yaml"
```

This is an example of files under modules/nexus/data

```
common.yaml
oses/family/RedHat.yaml
oses/family/Debian.yaml
oses/family/Windows.yaml
oses/family/Darwin.yaml
```

## Development

### My dev environment

This module was developed using

- Puppet 5.3.3
    - Hiera 3.4.2 (v5 format)
    - Facter 2.5.1
- CentOS 7.3
- Debian 8
- Vagrant 2.0.2 + VirtualBox 5.2.8
    - box: centos/7
    - box: debian/jessie64

### Author/Contributors

Igor Oliveira
