# @summary
#   Install opensearch via deb/rpm package.
#
# @api private
#
class opensearch::install::package {
  assert_private()

  if $opensearch::package_source == 'download' {
    if $opensearch::version =~ Undef {
      fail("Using 'opensearch::package_source: download' requires to set a version via 'opensearch::version: <version>'!")
    }

    $ensure   = $opensearch::package_ensure
    $provider = $opensearch::package_provider
    $file     = $opensearch::package_provider ? {
      'dpkg' => "opensearch-${opensearch::version}-linux-${opensearch::package_architecture}.deb",
      'rpm'  => "opensearch-${opensearch::version}-linux-${opensearch::package_architecture}.rpm",
    }
    $source   = "/tmp/${file}"

    archive { $source:
      provider => 'wget',
      extract  => false,
      cleanup  => true,
      source   => "https://artifacts.opensearch.org/releases/bundle/opensearch/${opensearch::version}/${file}",
    }

    Archive[$source] -> Package['opensearch']
  } else {
    $ensure   = pick($opensearch::version, $opensearch::package_ensure)
    $provider = undef
    $source   = undef
  }

  package { 'opensearch':
    ensure   => $ensure,
    provider => $provider,
    source   => $source,
  }
}
