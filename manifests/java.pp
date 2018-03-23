class nexus::java {

  class { 'java':
    distribution => $nexus::java_distribution,
  }

}
