# Internal class to config the Nexus instance
class nexus::config {

  $nexus_config_dir  = "${nexus::nexus_data_path}/nexus3/etc"
  $nexus_config_file = "${nexus::nexus_data_path}/nexus3/etc/nexus.properties"

  if $nexus::use_reserved_ports {
    $real_http_port  = 80
    $real_https_port = 443
  } else {
    $real_http_port  = $nexus::http_port
    $real_https_port = $nexus::https_port
  }

  file { $nexus_config_dir:
    ensure => directory,
    owner  => $nexus::nexus_user,
    group  => $nexus::nexus_group,
    mode   => '0755',
  }

  file { "${nexus::nexus_app_path}/bin/nexus.vmoptions":
    ensure  => present,
    owner   => $nexus::nexus_user,
    group   => $nexus::nexus_group,
    content => epp('nexus/nexus.vmoptions.epp', {
      xms            => $nexus::java_xms,
      xmx            => $nexus::java_xmx,
      max_direct_mem => $nexus::java_max_direct_mem,
      work_dir       => $nexus::nexus_data_path,
    }),
  }

  file { $nexus_config_file:
    ensure  => present,
    owner   => $nexus::nexus_user,
    group   => $nexus::nexus_group,
    content => epp('nexus/nexus.properties.epp', {
      http_port      => $real_http_port,
      https_port     => $real_https_port,
      enable_https   => $nexus::enable_https,
      listen_address => $nexus::listen_address,
    }),
  }

  # Sets the keystore password for Jetty
  augeas { 'nexus-keystore-password':
    incl    => "${nexus::nexus_app_path}/etc/jetty/jetty-https.xml",
    lens    => 'Xml.lns',
    context => "/files/${nexus::nexus_app_path}/etc/jetty/jetty-https.xml/Configure/New[2]",
    changes => [
      "set Set[2]/#text ${nexus::https_keystore_password}",
      "set Set[3]/#text ${nexus::https_keystore_password}",
      "set Set[5]/#text ${nexus::https_keystore_password}",
    ],
  }

}
