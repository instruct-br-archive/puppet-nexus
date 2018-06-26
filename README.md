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

** Note: this module was designed to install and manage Nexus Repository OSS >= 3.1, if you try to use a previous version, it may not work well. It also might not work well if you already have a Nexus installation. **

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

```puppet
class { 'nexus':
  http_listen_address => '192.168.250.80',
  http_port           => 8080,
  major_version       => 3,
  minor_version       => 7,
  release_version     => 1,
  revision            => 02,
}

nexus::api::blobstore::add { 'new_blobstore': }

nexus::api::repository::npm::hosted { 'npm-hosted':
  blobstore_name => 'new_blobstore',
}
nexus::api::repository::npm::proxy { 'npm-proxy':
  blobstore_name => 'new_blobstore',
}
# The npm-group's blobstore will be 'default'.
nexus::api::repository::npm::group { 'npm-group':
  members => ['maven-proxy', 'maven-hosted'],
}
```

#### Example in EL 7 with SSL enabled

```puppet
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

#### `user`

Type: String

User that will execute Nexus and own its directories

#### `group`

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


### Defined Types

#### nexus::api::script::add

Adds a new script using the Nexus API. It also let you execute the script right after adding, and delete after running.

Parameters:

#### `path``

Type: String

The path where the script is located.

#### `script_name`

Type: String

The name of the script that will be add.

#### `host`

Type: String

Host where the script will be uplodaded. Default to $nexus::listen_address (same address used to install Nexus).

#### `port`

Type: Integer

Port of the host where Nexus is listening. Default to $nexus::http_port (same port used to install Nexus).

#### `user`

Type: String

User to access the Nexus API. Default to 'admin' (default admin user).

#### `password`

Type: String

Password of the user to access the Nexus API. Default to 'admin123' (default admin password).

#### `run`

Type: Boolean

Whether to run the new script right after adding. Default to false.

#### `delete_after_run`

Type: Boolean

To be used with the previous parameter. Whether to delete the new script right after running. Default to false.

#### nexus::api::script::run

Run an existing script using the Nexus API.

Parameters:

#### `script_name`

Type: String

The name of the script that will be executed.

#### `host`

Type: String

Host where the script is and will be executed. Default to $nexus::listen_address (same address used to install Nexus).

#### `port`

Type: Integer

Port that Nexus is listening on the host where the script is. Default to $nexus::http_port (same port used to install Nexus).

#### `user`

Type: String

User to access the Nexus API. Default to 'admin' (default admin user).

#### `password`

Type: String

Password of the user to access the Nexus API. Default to 'admin123' (default admin password).


#### nexus::api::script::delete

Delete a script using the Nexus API.

Parameters:

#### `script_name`

Type: String

The name of the script that will be deleted.

#### `host`

Type: String

Host where the script is and will be deleted. Default to $nexus::listen_address (same address used to install Nexus).

#### `port`

Type: Integer

Port that Nexus is listening on the host where the script is. Default to $nexus::http_port (same port used to install Nexus).

#### `user`

Type: String

User to access the Nexus API. Default to 'admin' (default admin user).

#### `password`

Type: String

Password of the user to access the Nexus API. Default to 'admin123' (default admin password).

#### nexus::api::blobstore::add

Defined type to create a new File BlobStore. Since it uses the defined type `nexus::api::script::add`, it has the parameters: `host`, `port`, `user` and `password`. It also has the following params:

The defined type's title is the name of the BlobStore.

#### `path`

Type: String

Path where the BlobStore will be stored. Default to `"${nexus::work_dir}/blobs"` (directory blobs inside the sonatype-work path defined on the Nexus installation).

#### nexus::api::repository::_format_::_type_

This module contains several defined types that allows you to create new repositories hosted, proxy and group (according to the support of each format). They also use the parameters `host`, `port`, `user` and `password`, and most of them have the following common parameters (also depending on the support of each repository format):

The defined type's title is the name of the Repository.

- For Group repositories:

#### `members`

Type: Array[String]

Members of the group repository. It doesn't validate if the repository is being created via Puppet, since you might want to use an already existing repository.

#### `blobstore_name`

Type: String

Name of the BlobStore where the repository's components and assets will be stored. Default to 'default' (default blobstore created on Nexus installation).

- For Proxy repositories:

#### `remote_url`

Type: String

URL for the Remote Storage. Default to the default registry of each format, except for the Raw repository, that has as default an empty string.

#### `strict`

Type: Boolean

Whether or not the repository should enforce strict content types. Default to true.

#### `blobstore_name`

Type: String

Name of the BlobStore where the repository's components and assets will be stored. Default to 'default' (default blobstore created on Nexus installation).

- For Hosted repositories:

#### `write_policy`

Type: Enum['ALLOW', 'ALLOW_ONCE', 'DENY']

Repository write policy. Accepts the values 'ALLOW' (Allow redeploy), 'ALLOW_ONCE' (Disable redeploy) and 'DENY' (Read-only). Default to 'ALLOW'.

#### `strict`

Type: Boolean

Whether or not the repository should enforce strict content types. Default to true.

#### `blobstore_name`

Type: String

Name of the BlobStore where the repository's components and assets will be stored. Default to 'default' (default blobstore created on Nexus installation).

#### List of all available repositories defined types and its additional parameters:

#### api::repository::bower::group
#### api::repository::bower::hosted
#### api::repository::bower::proxy
`rewrite_package_urls` - Type: Boolean - Whether to force Bower to retrieve packages through the proxy repository or not. Default to true.

#### api::repository::docker::group
`http_port`  - Type: String - Create an HTTP connector to the specified port. Default to 'null'.
`https_port` - Type: String - Create an HTTPS connector to the specified port. Default to 'null'.
`enable_v1`  - Type: Boolean - Allow clients to use the V1 API to interact with this Repository. Default to false.
#### api::repository::docker::hosted
`http_port`  - Type: String - Create an HTTP connector to the specified port. Default to 'null'.
`https_port` - Type: String - Create an HTTPS connector to the specified port. Default to 'null'.
`enable_v1`  - Type: Boolean - Allow clients to use the V1 API to interact with this Repository. Default to false.
#### api::repository::docker::proxy
`http_port`  - Type: String - Create an HTTP connector to the specified port. Default to 'null'.
`https_port` - Type: String - Create an HTTPS connector to the specified port. Default to 'null'.
`enable_v1`  - Type: Boolean - Allow clients to use the V1 API to interact with this Repository. Default to false.
`index`      - Type: Enum['REGISTRY', 'HUB', 'CUSTOM'] - Docker Index. Accepts values 'REGISTRY' (Use proxy registry), 'HUB' (Use Docker Hub), 'INDEX' (Custom Index). Default to 'REGISTRY'.
`custom_url` - Type: String - Location of Docker index (if the `index` parameter value is 'INDEX'). Default to an empty string.

#### api::repository::gitlfs::hosted

#### api::repository::maven::group
#### api::repository::maven::hosted
`version_policy` - Type: Enum['RELEASE', 'SNAPSHOT', 'MIXED'] - Version policy. Accepts values 'RELEASE', 'SNAPSHOT' and 'MIXED'.Default to 'RELEASE'.
`layout_policy`  - Type: Enum['STRICT', 'PERMISSIVE'] - Layout policy. Accepts values 'STRICT' and 'PERMISSIVE'. Default to 'STRICT'.
#### api::repository::maven::proxy
`version_policy` - Type: Enum['RELEASE', 'SNAPSHOT', 'MIXED'] - Version policy. Accepts values 'RELEASE', 'SNAPSHOT' and 'MIXED'.Default to 'RELEASE'.
`layout_policy`  - Type: Enum['STRICT', 'PERMISSIVE'] - Layout policy. Accepts values 'STRICT' and 'PERMISSIVE'. Default to 'STRICT'.

#### api::repository::npm::group
#### api::repository::npm::hosted
#### api::repository::npm::proxy

#### api::repository::nuget::group
#### api::repository::nuget::hosted
#### api::repository::nuget::proxy

#### api::repository::pypi::group
#### api::repository::pypi::hosted
#### api::repository::pypi::proxy

#### api::repository::raw::group
#### api::repository::raw::hosted
#### api::repository::raw::proxy

#### api::repository::rubygems::group
#### api::repository::rubygems::hosted
#### api::repository::rubygems::proxy

#### api::repository::yum::hosted
`depth` - Type: Integer[0, 5] - Repository depth. Default to 0.
#### api::repository::yum::proxy

** Note that you can declare create a repository of any type just passing the name as the title of the resource (and user and password if they're not the default anymore). **

### Hiera Keys

#### Common

```yaml
---
nexus::user: 'nexus'
nexus::group: 'nexus'
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

Igor Oliveira (igor at instruct dot com dot br)
