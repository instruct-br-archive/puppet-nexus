# == Define: define_name
#
define nexus::api::repository::maven::hosted (
  String $name                                         = '',
  String $blobstore_name                               = 'Default',
  Boolean $strict                                      = true,
  Enum['release', 'snapshot', 'mixed'] $version_policy = 'mixed',
  Enum['allow', 'deny', 'readonly'] $write_policy      = 'allow',
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
