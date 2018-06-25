# == Define: define_name
define nexus::api::script::add (
  String $path = '',
  String $script_name = '',
  String $host = $nexus::listen_address,
  Integer $port = $nexus::http_port,
  String $user = 'admin',
  String $password = 'admin123',
  Boolean $run = false,
) {

  exec { "add-script-${script_name}":
    command  => "curl -v -u ${user}:${password} --header \"Content-Type: application/json\" \"http://${host}:${port}/service/rest/v1/script/\" -d @${path}",
    provider => 'shell',
  }

  notify {"curl -v -u ${user}:${password} --header \"Content-Type: application/json\" \"http://${host}:${port}/service/rest/v1/script/\" -d ${path}":}

  if $run {
    nexus::api::script::run { "run-${script_name}":
      host        => $host,
      port        => $port,
      script_name => $script_name,
      user        => $user,
      password    => $password,
    }
  }
}
