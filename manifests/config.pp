# Internal class to config the Nexus instance
class nexus::config {

  $config_dir  = "${nexus::work_dir}/nexus3/etc"
  $config_file = "${nexus::work_dir}/nexus3/etc/nexus.properties"

  file { $config_dir:
    ensure => directory,
    owner  => $nexus::user,
    group  => $nexus::group,
    mode   => '0755',
  }

  file { "${nexus::app_path}/bin/nexus.vmoptions":
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/nexus.vmoptions.epp', {
      xms            => $nexus::java_xms,
      xmx            => $nexus::java_xmx,
      max_direct_mem => $nexus::java_max_direct_mem,
      work_dir       => $nexus::work_dir,
    }),
  }

  file { $config_file:
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/nexus.properties.epp', {
      http_port      => $nexus::http_port,
      https_port     => $nexus::https_port,
      enable_https   => $nexus::enable_https,
      listen_address => $nexus::listen_address,
    }),
  }

  # Sets the keystore password for Jetty
  augeas { 'nexus-keystore-password':
    incl    => "${nexus::app_path}/etc/jetty/jetty-https.xml",
    lens    => 'Xml.lns',
    context => "/files/${nexus::app_path}/etc/jetty/jetty-https.xml/Configure/New[2]",
    changes => [
      "set Set[2]/#text ${nexus::https_keystore_password}",
      "set Set[3]/#text ${nexus::https_keystore_password}",
      "set Set[5]/#text ${nexus::https_keystore_password}",
    ],
  }

}
