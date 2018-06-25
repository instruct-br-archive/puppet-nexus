# == Define: define_name
#
define nexus::api::repository::docker::group (
  String $name                                         = '',
  Array[String] $members                               = '',
  Optional[Integer] $http_port                         = undef,
  Optional[Integer] $https_port                        = undef,
  Boolean $enable_v1                                   = false,
  String $blobstore_name                               = 'Default',
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
