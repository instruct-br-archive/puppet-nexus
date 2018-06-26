# == Define: nexus::api::repository::rubygems::proxy
#
define nexus::api::repository::rubygems::proxy (
  String $remote_url     = 'https://rubygems.org',
  String $blobstore_name = 'default',
  Boolean $strict        = true,
  String $host           = $nexus::listen_address,
  Integer $port          = $nexus::http_port,
  String $user           = 'admin',
  String $password       = 'admin123',
) {

  file { "/tmp/repository-rubygems-${name}.json":
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/api/repository/rubygems/proxy.json.epp', {
      repository_name => $name,
      remote_url      => $remote_url,
      blobstore_name  => $blobstore_name,
      strict          => $strict,
    }),
  }

  nexus::api::script::add { "add-repository-rubygems-${name}-script":
    path             => "/tmp/repository-rubygems-${name}.json",
    script_name      => $name,
    host             => $host,
    port             => $port,
    user             => $user,
    password         => $password,
    run              => true,
    delete_after_run => true,
  }

}
