# == Define: define_name
#
define nexus::api::repository::docker::proxy (
  String $remote_url             = 'https://registry-1.docker.io',
  String $blobstore_name         = 'default',
  Boolean $strict                = true,
  Enum['REGISTRY', 'HUB', 'CUSTOM'] $index = 'REGISTRY',
  String $custom_url             = 'null',
  String $http_port              = 'null',
  String $https_port             = 'null',
  Boolean $enable_v1             = false,
  String $host                   = $nexus::listen_address,
  Integer $port                  = $nexus::http_port,
  String $user                   = 'admin',
  String $password               = 'admin123',
) {

  file { "/tmp/repository-docker-${name}.json":
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/api/repository/docker/proxy.json.epp', {
      repository_name => $name,
      http_port       => $http_port,
      https_port      => $https_port,
      enable_v1       => $enable_v1,
      index           => $index,
      custom_url      => $custom_url,
      remote_url      => $remote_url,
      blobstore_name  => $blobstore_name,
      strict          => $strict,
    }),
  }

  nexus::api::script::add { "add-repository-docker-${name}-script":
    path             => "/tmp/repository-docker-${name}.json",
    script_name      => $name,
    host             => $host,
    port             => $port,
    user             => $user,
    password         => $password,
    run              => true,
    delete_after_run => true,
  }

}
