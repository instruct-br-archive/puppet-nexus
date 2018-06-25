# == Define: define_name
#
define nexus::api::repository::maven::proxy (
  String $name                                         = '',
  String $remote_url                                   = 'https://repo1.maven.org/maven2/',
  String $blobstore_name                               = 'Default',
  Boolean $strict                                      = true,
  Enum['release', 'snapshot', 'mixed'] $version_policy = 'mixed',
  Enum['strict', 'permissive'] $layout_policy          = 'strict',
  String $host                                         = $nexus::listen_address,
  String $port                                         = $nexus::http_port,
  String $user                                         = 'admin',
  String $password                                     = 'admin123',
) {

  file { '/tmp/${name}.json':

  }

  nexus::api::script::add {
    path        => "/tmp/${name}.json",
    script_name => $name,
    host        => $host,
    port        => $port,
    user        => $user,
    password    => $password,
    run         => true,
  }

}
