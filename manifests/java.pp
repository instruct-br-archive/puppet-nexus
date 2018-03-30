# Internal class to install the JVM
class nexus::java {

  class { 'java':
    distribution => $nexus::java_distribution,
  }

}
