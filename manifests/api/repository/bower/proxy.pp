# == Define: define_name
#
define nexus::api::repository::bower::proxy (
  String $remote_url     = 'https://registry.bower.io',
  String $blobstore_name = 'default',
  Boolean $rewrite_package_urls = true,
  Boolean $strict        = true,
  String $host           = $nexus::listen_address,
  Integer $port          = $nexus::http_port,
  String $user           = 'admin',
  String $password       = 'admin123',
) {

  file { "/tmp/repository-bower-${name}.json":
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/api/repository/bower/proxy.json.epp', {
      repository_name      => $name,
      remote_url           => $remote_url,
      blobstore_name       => $blobstore_name,
      strict               => $strict,
      rewrite_package_urls => $rewrite_package_urls,
    }),
  }

  nexus::api::script::add { "add-repository-bower-${name}-script":
    path             => "/tmp/repository-bower-${name}.json",
    script_name      => $name,
    host             => $host,
    port             => $port,
    user             => $user,
    password         => $password,
    run              => true,
    delete_after_run => true,
  }

}
