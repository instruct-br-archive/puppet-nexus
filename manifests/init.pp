# Nexus class.
#
# This is a class to install and manage Nexus 3:
#
# @example Declaring the class
#   include nexus
#
# @param [String] nexus_user User that will execute Nexus and own its directories
# @param [String] nexus_group Group for Nexus user
# @param [String] temp_path Path where the file will be downloaded before extraction
# @param [String] install_path Path where the Nexus will be extracted
# @param [String] service_name Name for Nexus's service
# @param [String] service_provider Service provider
# @param [String] os_ext Extension for filename that depends on OS
# @param [String] major_version Nexus's major version
# @param [String] minor_version Nexus's minor version
# @param [String] revision Nexus revision
# @param [Integer] http_port Port to serve HTTP
# @param [Integer] https_port Port to serve HTTPS
# @param [String] listen_address IP address Nexus listen (same for http and https)
# @param [Boolean] enable_https Whether to enable HTTPS or not
# @param [String] https_keystore Path to the keystore.jks
# @param [String] https_keystore_password Password to access the keystore

class nexus (
  String $nexus_user,
  String $nexus_group,
  String $temp_path,
  String $install_path,
  String $service_name,
  String $service_provider,
  String $os_ext,
  String $major_version,
  String $minor_version,
  String $revision,
  Integer[1024,65535] $http_port,
  Integer[1024,65535] $https_port,
  String $listen_address,
  Boolean $enable_https           = false,
  String $https_keystore          = '',
  String $https_keystore_password = '',
) {

  $nexus_version = "nexus-3.${nexus::major_version}.${nexus::minor_version}-${nexus::revision}"
  $nexus_app_path = "${nexus::install_path}/${nexus_version}"
  $nexus_data_path = "${nexus::install_path}/sonatype-work"

  include nexus::install
  include nexus::service
  include nexus::config

  Class['nexus::install']
    -> Class['nexus::config']
      -> Class['nexus::service']

}
