# == Define: nexus::api::repository::maven::proxy
#
define nexus::api::repository::maven::proxy (
  String $remote_url                                   = 'https://repo1.maven.org/maven2/',
  String $blobstore_name                               = 'default',
  Boolean $strict                                      = true,
  Enum['RELEASE', 'SNAPSHOT', 'MIXED'] $version_policy = 'RELEASE',
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
    content => epp('nexus/api/repository/maven/proxy.json.epp', {
      repository_name => $name,
      remote_url      => $remote_url,
      blobstore_name  => $blobstore_name,
      strict          => $strict,
      version_policy  => $version_policy,
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
