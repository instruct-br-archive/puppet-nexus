# Internal class to install Nexus
class nexus::install {

  if "${nexus::major_version}.${nexus::minor_version}" < '3.1' {
    fail("This module supports version 3.1 or greater, found: \'${nexus::major_version}.${nexus::minor_version}\'")
  }

  group { $nexus::group:
    ensure => present,
  }

  user { $nexus::user:
    ensure     => present,
    groups     => [$nexus::group, 'root'],
    home       => $nexus::install_path,
    managehome => true,
    shell      => '/bin/bash',
  }

  File {
    owner => $nexus::user,
    group => $nexus::group,
  }

  file { $nexus::temp_path:
    ensure => directory,
  }

  file { $nexus::data_path:
    ensure => directory,
    mode   => '0755',
  }

  archive { "${nexus::temp_path}/nexus-${nexus::os_ext}":
    ensure        => present,
    extract       => true,
    extract_path  => $nexus::install_path,
    source        => "https://download.sonatype.com/nexus/3/${nexus::version}-${nexus::os_ext}",
    checksum_url  => "https://download.sonatype.com/nexus/3/${nexus::version}-${nexus::os_ext}.sha1",
    checksum_type => 'sha1',
    cleanup       => true,
  }

  file { $nexus::app_path:
    ensure  => directory,
    recurse => true,
  }

  file { $nexus::work_dir:
    ensure  => directory,
    recurse => true,
    source => "file:///${nexus::install_path}/sonatype-work",
  }

  case $facts['os']['family'] {
    'Debian', 'RedHat': {
      file { "/etc/systemd/system/${nexus::service_name}.service":
        mode    => '0644',
        content => epp('nexus/nexus.systemd.epp', {
          path  => $nexus::app_path,
          user  => $nexus::user,
          group => $nexus::group
        }),
      }
    }
    # Needs to be tested
    #
    # 'Darwin': {
    #   file { '/Library/LaunchDaemons/${nexus::service_name}.plist':
    #     mode    => '0644',
    #     owner   => 'root',
    #     group   => 'wheel',
    #     content => epp('nexus/com.sonatype.nexus.plist.epp', {path => $nexus::app_path}),
    #   }
    # }
    # 'Windows': {
    #   exec { 'Create Nexus Service':
    #     command => "nexus.exe /install ${nexus::service_name}",
    #     path    => "${nexus::app_path}/bin",
    #   }
    # }
    default: {
      notify { 'OS not supported': }
    }
  }
}
