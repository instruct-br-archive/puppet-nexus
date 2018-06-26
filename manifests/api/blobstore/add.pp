# == Define: nexus::api::blobstore::add
#
define nexus::api::blobstore::add (
  String $path     = "${nexus::work_dir}/blobs",
  String $host     = $nexus::listen_address,
  Integer $port    = $nexus::http_port,
  String $user     = 'admin',
  String $password = 'admin123',
) {

  # Script based on https://github.com/sonatype/nexus-public/blob/master/components/nexus-core/src/main/java/org/sonatype/nexus/BlobStoreApi.java
  file { "/tmp/blobstore-${name}.json":
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/api/blobstore/add.json.epp', {
      blobstore_name => $name,
      blobstore_path => "${path}/${name}",
    }),
  }

  nexus::api::script::add { "add-blobstore-${name}-script":
    path             => "/tmp/blobstore-${name}.json",
    script_name      => $name,
    host             => $host,
    port             => $port,
    user             => $user,
    password         => $password,
    run              => true,
    delete_after_run => true,
  }

}
