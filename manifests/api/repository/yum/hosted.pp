# == Define: define_name
#
define nexus::api::repository::yum::hosted (
  String $name           = '',
  String $blobstore_name = 'Default',
  Boolen $strict         = true,
  Integer $depth         = 0,
  Enum['allow', 'deny', 'readonly'] $write_policy      = 'allow',
  String $host           = $nexus::listen_address,
  String $port           = $nexus::http_port,
  String $user           = 'admin',
  String $password       = 'admin123',
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
