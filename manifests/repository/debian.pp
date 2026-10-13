# @summary
#  Install the Debian apt repository for opensearch.
#
# @api private
#
class opensearch::repository::debian {
  assert_private()

  $location = $opensearch::version =~ Undef ? {
    true  => pick($opensearch::repository_location, 'https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/apt'),
    false => pick($opensearch::repository_location, "https://artifacts.opensearch.org/releases/bundle/opensearch/${opensearch::version[0]}.x/apt"),
  }

  $key_name = if $opensearch::version and versioncmp($opensearch::version, '3') >= 0 {
    'opensearch-3.asc'
  } else {
    'opensearch-2.asc'
  }

  apt::source { 'opensearch':
    ensure   => $opensearch::repository_ensure,
    location => $location,
    release  => 'stable',
    repos    => 'main',
    key      => {
      'name'   => $key_name,
      'source' => $opensearch::real_repository_gpg_key,
    },
  }

  include apt

  if $opensearch::manage_package {
    Apt::Source['opensearch'] ~> Exec['apt_update'] -> Package['opensearch']
  } else {
    Apt::Source['opensearch'] ~> Exec['apt_update']
  }
}
