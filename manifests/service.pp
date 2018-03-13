class nexus::service {

  service { $nexus::service_name:
    ensure     => running,
    provider   => $nexus::service_provider,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

}
