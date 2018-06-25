# == Define: define_name
#
define nexus::api::repository::gitlfs::hosted (
  String $blobstore_name = 'default',
  Boolean $strict        = true,
  Enum['ALLOW', 'ALLOW_ONCE', 'DENY'] $write_policy = 'ALLOW',
  String $host           = $nexus::listen_address,
  Integer $port          = $nexus::http_port,
  String $user           = 'admin',
  String $password       = 'admin123',
) {

  file { "/tmp/repository-gitlfs-${name}.json":
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/api/repository/gitlfs/hosted.json.epp', {
      repository_name => $name,
      blobstore_name  => $blobstore_name,
      strict          => $strict,
      write_policy    => $write_policy,
    }),
  }

  nexus::api::script::add { "add-repository-${name}-script":
    path             => "/tmp/repository-gitlfs-${name}.json",
    script_name      => $name,
    host             => $host,
    port             => $port,
    user             => $user,
    password         => $password,
    run              => true,
    delete_after_run => true,
  }

}
