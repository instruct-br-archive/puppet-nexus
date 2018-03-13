class nexus::config {

  $nexus_config_file = "${nexus::nexus_data_path}/nexus3/etc/nexus.properties"

  file { $nexus_config_file:
    ensure =>  present,
  }

  file_line { 'nexus-application-host':
    path  => $nexus_config_file,
    match => '^application-host',
    line  => "application-host=${nexus::listen_address}"
  }

  file_line { 'nexus-application-port':
    path  => $nexus_config_file,
    match => '^application-port',
    line  => "application-port=${nexus::http_port}"
  }

  if $nexus::enable_https {

    file_line { 'nexus-application-https-port':
      ensure => present,
      path   => $nexus_config_file,
      line   => "application-port-ssl=${nexus::https_port}"
    }

    file_line { 'nexus-application-java-args':
      path  => $nexus_config_file,
      match => '^nexus-java_args',
      line  => 'nexus-java-args=${jetty.etc}/jetty.xml,${jetty.etc}/jetty-http.xml,${jetty.etc}/jetty-requestlog.xml,${jetty.etc}/jetty-https.xml,${jetty.etc}/jetty-http-redirect-to-https.xml'
    }

    file_line { 'nexus-keystore-password':
      path  => "${nexus::nexus_app_path}/etc/jetty/jetty-https.xml",
      match => '^.*KeyStorePassword',
      line  => "    <Set name=\"KeyStorePassword\">${nexus::https_keystore_password}</Set>",
    }

    file_line { 'nexus-keymanager-password':
      path  => "${nexus::nexus_app_path}/etc/jetty/jetty-https.xml",
      match => '^.*KeyManagerPassword',
      line  => "    <Set name=\"KeyManagerPassword\">${nexus::https_keystore_password}</Set>"
    }

    file_line { 'nexus-trutstore-password':
      path  => "${nexus::nexus_app_path}/etc/jetty/jetty-https.xml",
      match => '^.*TrustStorePassword',
      line  => "    <Set name=\"TrustStorePassword\">${nexus::https_keystore_password}</Set>"
    }

  }

}
