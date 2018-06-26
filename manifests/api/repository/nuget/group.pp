# == Define: nexus::api::repository::nuget::group
#
define nexus::api::repository::nuget::group (
  Array[String] $members = '',
  String $blobstore_name = 'default',
  String $host           = $nexus::listen_address,
  Integer $port          = $nexus::http_port,
  String $user           = 'admin',
  String $password       = 'admin123',
) {

  file { "/tmp/repository-nuget-${name}.json":
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/api/repository/nuget/group.json.epp', {
      repository_name => $name,
      blobstore_name  => $blobstore_name,
      members         => $members,
    }),
  }

  nexus::api::script::add { "add-repository-nuget-${name}-script":
    path             => "/tmp/repository-nuget-${name}.json",
    script_name      => $name,
    host             => $host,
    port             => $port,
    user             => $user,
    password         => $password,
    run              => true,
    delete_after_run => true,
  }

}
