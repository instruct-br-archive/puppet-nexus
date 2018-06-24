# Internal class to manage Nexus service
class nexus::service {

  class { '::systemd::systemctl::daemon_reload':
    subscribe => File["/etc/systemd/system/${nexus::service_name}.service"],
    notify    => Service[$nexus::service_name],
  }

  service { $nexus::service_name:
    ensure     => running,
    provider   => $nexus::service_provider,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

}
