# == Define: define_name
#
define nexus::api::repository::maven::hosted (
  String $blobstore_name                               = 'default',
  Boolean $strict                                      = true,
  Enum['RELEASE', 'SNAPSHOT', 'MIXED'] $version_policy = 'RELEASE',
  Enum['ALLOW', 'ALLOW_ONCE', 'DENY'] $write_policy    = 'ALLOW',
  Enum['STRICT', 'PERMISSIVE'] $layout_policy          = 'STRICT',
  String $host                                         = $nexus::listen_address,
  Integer $port                                        = $nexus::http_port,
  String $user                                         = 'admin',
  String $password                                     = 'admin123',
) {

  file { "/tmp/repository-maven-${name}.json":
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/api/repository/maven/hosted.json.epp', {
      repository_name => $name,
      blobstore_name  => $blobstore_name,
      strict          => $strict,
      version_policy  => $version_policy,
      write_policy    => $write_policy,
      layout_policy   => $layout_policy,
    }),
  }

  nexus::api::script::add { "add-repository-maven-${name}-script":
    path             => "/tmp/repository-maven-${name}.json",
    script_name      => $name,
    host             => $host,
    port             => $port,
    user             => $user,
    password         => $password,
    run              => true,
    delete_after_run => true,
  }
}
