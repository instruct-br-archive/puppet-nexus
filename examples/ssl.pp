## first generate a certificate
## puppet cert generate nexus

java_ks { 'nexus_keystore_base':
  ensure       => latest,
  certificate  => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  target       => "${nexus::nexus_path}/etc/ssl/keystore.jks",
  password     => 'puppet',
  trustcacerts => true,
}

java_ks { 'nexus_keystore_certs':
  ensure              => latest,
  certificate         => '/etc/puppetlabs/puppet/ssl/certs/nexus.pem',
  private_key         => '/etc/puppetlabs/puppet/ssl/private_keys/nexus.pem',
  private_key_type    => 'rsa',
  target              => "${nexus::nexus_path}/etc/ssl/keystore.jks",
  password            => 'puppet',
  password_fail_reset => true,
}

class { 'nexus':
  enable_https            => true,
  http_listen_address     => '192.168.250.80',
  https_listen_address    => '192.168.250.80',
  https_port              => 8081,
  https_keystore          => "${nexus::nexus_path}/etc/ssl/keystore.jks",
  https_keystore_password => 'puppet',
}
