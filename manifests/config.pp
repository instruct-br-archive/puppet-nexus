# Internal class to config the Nexus instance
class nexus::config {

  $nexus_config_dir  = "${nexus::nexus_data_path}/nexus3/etc"
  $nexus_config_file = "${nexus::nexus_data_path}/nexus3/etc/nexus.properties"

  file { $nexus_config_dir:
    ensure => directory,
    owner  => $nexus::nexus_user,
    group  => $nexus::nexus_group,
    mode   => '0755',
  }

  file { $nexus_config_file:
    ensure  => present,
    owner   => $nexus::nexus_user,
    group   => $nexus::nexus_group,
    content => epp('nexus/nexus.properties.epp', {
      http_port      => $nexus::http_port,
      https_port     => $nexus::https_port,
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
