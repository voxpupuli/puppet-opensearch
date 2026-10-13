# @summary
#  Install the RedHat yum repository for opensearch.
#
# @api private
#
class opensearch::repository::redhat {
  assert_private()

  $baseurl = $opensearch::version =~ Undef ? {
    true  => pick($opensearch::repository_location, 'https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/yum'),
    false => pick($opensearch::repository_location, "https://artifacts.opensearch.org/releases/bundle/opensearch/${opensearch::version[0]}.x/yum"),
  }

  $key_version = if $opensearch::version and versioncmp($opensearch::version, '3') >= 0 {
    '3'
  } else {
    '2'
  }

  if $opensearch::repository_gpg_key =~ Undef {
    $key_path = "/etc/pki/rpm-gpg/RPM-GPG-KEY-opensearch-${key_version}"

    file { $key_path:
      ensure => $opensearch::repository_ensure,
      source => "puppet:///modules/opensearch/opensearch-${key_version}.asc",
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    $gpgkey = "file://${key_path}"
  } else {
    $gpgkey = $opensearch::real_repository_gpg_key
  }

  yumrepo { 'opensearch':
    ensure        => $opensearch::repository_ensure,
    descr         => 'OpenSearch',
    baseurl       => $baseurl,
    repo_gpgcheck => '1',
    gpgcheck      => '1',
    gpgkey        => $gpgkey,
  }

  if $opensearch::repository_gpg_key =~ Undef {
    File[$key_path] -> Yumrepo['opensearch']
  }
}
