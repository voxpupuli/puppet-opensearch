# @summary
#  Install yum repository and package.
#
# @api private
#
class opensearch::install::repository::redhat {
  assert_private()

  yumrepo { 'OpenSearch 2.x':
    ensure        => $opensearch::package_ensure,
    baseurl       => 'https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/yum',
    repo_gpgcheck => '1',
    gpgcheck      => '1',
    gpgkey        => 'https://artifacts.opensearch.org/publickeys/opensearch.pgp',
  }

  package { 'opensearch':
    ensure => $opensearch::package_ensure,
  }

  Yumrepo['OpenSearch 2.x'] -> Package['opensearch']
}
