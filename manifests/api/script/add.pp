# == Define: nexus::api::script::add
#
define nexus::api::script::add (
  String $path = '',
  String $script_name = '',
  String $host = $nexus::listen_address,
  Integer $port = $nexus::http_port,
  String $user = 'admin',
  String $password = 'admin123',
  Boolean $run = false,
  Boolean $delete_after_run = false,
) {

  if $host != $nexus::listen_address or $facts['nexus_running'] {
    exec { "add-script-${script_name}":
      command  => "curl -v -u ${user}:${password} --header \"Content-Type: application/json\" \"http://${host}:${port}/service/rest/v1/script/\" -d @${path}",
      provider => 'shell',
    }

    if $run {
      nexus::api::script::run { "run-${script_name}":
        host        => $host,
        port        => $port,
        script_name => $script_name,
        user        => $user,
        password    => $password,
      }
    }

    if $delete_after_run {
      nexus::api::script::delete { "delete-${script_name}":
        host        => $host,
        port        => $port,
        script_name => $script_name,
        user        => $user,
        password    => $password,
        require     => Nexus::Api::Script::Run["run-${script_name}"],
      }
    }
  } else {
    fail('Please, ensure that Nexus service is running before try to use its API.')
  }
}
