# @summary
#   Install opensearch via deb/rpm package.
#
# @api private
#
class opensearch::install::package (
  $architecture = $opensearch::package_architecture,
  $ensure       = $opensearch::package_ensure,
  $provider     = $opensearch::package_provider,
  $version      = $opensearch::version,
) {
  assert_private()

  $file = $provider ? {
    'dpkg' => "opensearch-${version}-linux-${architecture}.deb",
    'rpm'  => "opensearch-${version}-linux-${architecture}.rpm",
  }

  archive { "/tmp/${file}":
    provider => 'wget',
    extract  => false,
    cleanup  => true,
    source   => "https://artifacts.opensearch.org/releases/bundle/opensearch/${version}/${file}",
  }

  package { 'opensearch':
    ensure   => $ensure,
    provider => $provider,
    source   => "/tmp/${file}",
  }
}
