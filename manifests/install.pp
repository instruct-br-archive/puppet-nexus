class nexus::install {

  class { 'java':
    distribution => 'jre',
  }

  group { $nexus::nexus_group:
    ensure => present,
  }

  user { $nexus::nexus_user:
    ensure => present,
    groups => [$nexus::nexus_group, 'root'],
    home   => '/home/nexus',
    shell  => '/bin/bash',
  }

  file { $nexus::temp_path:
    ensure => directory,
  }

  file { $nexus::install_path:
    ensure => directory,
    owner  => $nexus::nexus_user,
    group  => $nexus::nexus_group,
    mode   => '0755',
  }

  archive { "${nexus::temp_path}/nexus-${nexus::os_ext}":
    ensure        => present,
    extract       => true,
    extract_path  => $nexus::install_path,
    source        => "https://download.sonatype.com/nexus/3/${nexus::nexus_version}-${nexus::os_ext}",
    checksum_url  => "https://download.sonatype.com/nexus/3/${nexus::nexus_version}-${nexus::os_ext}.sha1",
    checksum_type => 'sha1',
    cleanup       => true,
  }

  file { $nexus::nexus_app_path:
    ensure  => directory,
    owner   => $nexus::nexus_user,
    group   => $nexus::nexus_group,
    recurse => true,
  }

  file { $nexus::nexus_data_path:
    ensure  => directory,
    owner   => $nexus::nexus_user,
    group   => $nexus::nexus_group,
    recurse => true,
  }

  case $facts['os']['family'] {
    'Debian', 'RedHat': {
      file { "/etc/systemd/system/${nexus::service_name}.service":
        mode    => '0644',
        owner   => 'nexus',
        group   => 'nexus',
        content => epp('nexus/nexus.systemd.epp', {nexus_path => $nexus::nexus_app_path, nexus_user => $nexus::nexus_user, nexus_group => $nexus::nexus_group}),
      }
    }
    # Needs to be tested
    #
    # 'Darwin': {
    #   file { '/Library/LaunchDaemons/${nexus::service_name}.plist':
    #     mode    => '0644',
    #     owner   => 'root',
    #     group   => 'wheel',
    #     content => epp('nexus/com.sonatype.nexus.plist.epp', {nexus_path => $nexus::nexus_app_path}),
    #   }
    # }
    # 'Windows': {
    #   exec { 'Create Nexus Service':
    #     command => "nexus.exe /install ${nexus::service_name}",
    #     path    => "${nexus::nexus_app_path}/bin",
    #   }
    # }
    default: {
      notify { 'OS not supported': }
    }
  }
}
