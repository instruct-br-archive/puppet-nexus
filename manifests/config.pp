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
    owner  => $nexus::nexus_user,
    group  => $nexus::nexus_group,
    content => epp('nexus/nexus.properties.epp', {http_port => $nexus::http_port, listen_address => $nexus::listen_address}),
  }

  file_line { 'nexus-application-host':
    path  => $nexus_config_file,
    match => '^application-host',
    line  => "application-host=${nexus::listen_address}",
  }

  file_line { 'nexus-application-port':
    path  => $nexus_config_file,
    match => '^application-port',
    line  => "application-port=${nexus::http_port}",
  }

  if $nexus::enable_https {

    file_line { 'nexus-application-https-port':
      ensure => present,
      path   => $nexus_config_file,
      line   => "application-port-ssl=${nexus::https_port}",
    }

    file_line { 'nexus-application-args':
      path  => $nexus_config_file,
      match => '^nexus-args',
      line  => 'nexus-args=${jetty.etc}/jetty.xml,${jetty.etc}/jetty-http.xml,${jetty.etc}/jetty-requestlog.xml,${jetty.etc}/jetty-https.xml,${jetty.etc}/jetty-http-redirect-to-https.xml',
    }

    # augeas nos xml

    augeas{ 'nexus-keystore-password':
      incl    => "${nexus::nexus_app_path}/etc/jetty/jetty-https.xml",
      lens    => "Xml.lns",
      context => "/files/${nexus::nexus_app_path}/etc/jetty/jetty-https.xml/Configure/New[2]",
      changes => ["set Set[2]/#text ${nexus::https_keystore_password}",
                  "set Set[3]/#text ${nexus::https_keystore_password}",
                  "set Set[5]/#text ${nexus::https_keystore_password}"]
    }

    # file_line { 'nexus-keystore-password':
    #   path  => "${nexus::nexus_app_path}/etc/jetty/jetty-https.xml",
    #   match => '^.*KeyStorePassword',
    #   line  => "    <Set name=\"KeyStorePassword\">${nexus::https_keystore_password}</Set>",
    # }
    #
    # file_line { 'nexus-keymanager-password':
    #   path  => "${nexus::nexus_app_path}/etc/jetty/jetty-https.xml",
    #   match => '^.*KeyManagerPassword',
    #   line  => "    <Set name=\"KeyManagerPassword\">${nexus::https_keystore_password}</Set>",
    # }
    #
    # file_line { 'nexus-trutstore-password':
    #   path  => "${nexus::nexus_app_path}/etc/jetty/jetty-https.xml",
    #   match => '^.*TrustStorePassword',
    #   line  => "    <Set name=\"TrustStorePassword\">${nexus::https_keystore_password}</Set>",
    # }

  }

}
