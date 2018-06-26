# == Define: nexus::api::script::run
#
define nexus::api::script::run (
  String $host        = $nexus::listen_address,
  Integer $port       = $nexus::http_port,
  String $script_name = '',
  String $user        = '',
  String $password    = '',
) {

  if $host != $nexus::listen_address or $facts['nexus_running'] {
    exec { "run-script-${script_name}":
      command  => "curl -v -X POST -u ${user}:${password} --header \"Content-Type: text/plain\" \"http://${host}:${port}/service/rest/v1/script/${script_name}/run\"",
      provider => 'shell',
    }
  } else {
    fail('Please, ensure that Nexus service is running before try to use its API.')
  }

}
