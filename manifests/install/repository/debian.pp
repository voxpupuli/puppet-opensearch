# @summary
#  Install debian repository and package.
#
# @api private
#
class opensearch::install::repository::debian {
  assert_private()

  include apt

  archive { '/tmp/opensearch.pgp':
    ensure          => $opensearch::package_ensure,
    source          => 'https://artifacts.opensearch.org/publickeys/opensearch.pgp',
    extract         => true,
    extract_path    => '/usr/share/keyrings',
    extract_command => 'gpg --dearmor < %s > opensearch.keyring.gpg',
    creates         => '/usr/share/keyrings/opensearch.keyring.gpg',
  }

  apt::source { 'opensearch':
    ensure   => $opensearch::package_ensure,
    location => 'https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/apt',
    release  => 'stable',
    repos    => 'main',
    keyring  => '/usr/share/keyrings/opensearch.keyring.gpg',
  }

  package { 'opensearch':
    ensure => $opensearch::package_ensure,
  }

  Archive['/tmp/opensearch.pgp'] -> Apt::Source['opensearch'] ~> Class['apt::update'] -> Package['opensearch']
}
