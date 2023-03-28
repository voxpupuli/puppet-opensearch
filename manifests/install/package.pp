# @summary
#   Install opensearch via deb/rpm package.
#
# @api private
#
class opensearch::install::package {
  assert_private()

  $file = $opensearch::package_provider ? {
    'dpkg' => "opensearch-${opensearch::version}-linux-${opensearch::package_architecture}.deb",
    'rpm'  => "opensearch-${opensearch::version}-linux-${opensearch::package_architecture}.rpm",
  }

  archive { "/tmp/${file}":
    provider => 'wget',
    extract  => false,
    cleanup  => true,
    source   => "https://artifacts.opensearch.org/releases/bundle/opensearch/${opensearch::version}/${file}",
  }

  package { 'opensearch':
    ensure   => $opensearch::package_ensure,
    provider => $opensearch::package_provider,
    source   => "/tmp/${file}",
  }
}
