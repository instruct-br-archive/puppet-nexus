# == Define: nexus::api::repository::docker::hosted
#
define nexus::api::repository::docker::hosted (
  String $blobstore_name        = 'default',
  Boolean $strict               = true,
  Enum['ALLOW', 'ALLOW_ONCE', 'DENY'] $write_policy = 'ALLOW',
  String $http_port             = 'null',
  String $https_port            = 'null',
  Boolean $enable_v1            = false,
  String $host                  = $nexus::listen_address,
  Integer $port                 = $nexus::http_port,
  String $user                  = 'admin',
  String $password              = 'admin123',
) {

  file { "/tmp/repository-docker-${name}.json":
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/api/repository/docker/hosted.json.epp', {
      repository_name => $name,
      http_port       => $http_port,
      https_port      => $https_port,
      enable_v1       => $enable_v1,
      blobstore_name  => $blobstore_name,
      strict          => $strict,
      write_policy    => $write_policy,
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
