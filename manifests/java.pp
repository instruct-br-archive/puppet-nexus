# Internal class to install the JVM
class nexus::java {

  class { 'java':
    distribution => $nexus::java_distribution,
  }

  $java_path = "/etc/alternatives/${nexus::java_distribution}"

  if $nexus::use_reserved_ports {
    ldconfig::entry { 'java':
      paths   => [
        "${java_path}/lib/amd64/jli",
        "${java_path}/lib/i386/jli",
      ],
      require => [
        Class['java'],
      ],
    }

    # http://man7.org/linux/man-pages/man7/capabilities.7.html
    file_capability { "${java_path}/bin/java":
      ensure     => present,
      capability => [
        'cap_net_bind_service=epi',
      ],
      require    => [
        Ldconfig::Entry['java'],
      ],
    }
  }

}
