# == Class: class_name
#
define nexus::api::script::delete (
  String $host        = $nexus::listen_address,
  Integer $port       = $nexus::http_port,
  String $script_name = '',
  String $user        = '',
  String $password    = '',
) {

  if $host != $nexus::listen_address or $facts['nexus_running'] {
    exec { "delete-script-${script_name}":
      command  => "curl -v -X DELETE -u ${user}:${password} \"http://${host}:${port}/service/rest/v1/script/${script_name}\"",
      provider => 'shell',
    }
  } else {
    fail('Please, ensure that Nexus service is running before try to use its API.')
  }

}
