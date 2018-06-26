# == Define: nexus::api::repository::raw::proxy
#
define nexus::api::repository::raw::proxy (
  String $remote_url     = '',
  String $blobstore_name = 'default',
  Boolean $strict        = true,
  String $host           = $nexus::listen_address,
  Integer $port          = $nexus::http_port,
  String $user           = 'admin',
  String $password       = 'admin123',
) {

  file { "/tmp/repository-raw-${name}.json":
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/api/repository/raw/proxy.json.epp', {
      repository_name => $name,
      remote_url      => $remote_url,
      blobstore_name  => $blobstore_name,
      strict          => $strict,
    }),
  }

  nexus::api::script::add { "add-repository-raw-${name}-script":
    path             => "/tmp/repository-raw-${name}.json",
    script_name      => $name,
    host             => $host,
    port             => $port,
    user             => $user,
    password         => $password,
    run              => true,
    delete_after_run => true,
  }

}
