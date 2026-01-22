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

    if $opensearch::manage_repository {
      contain opensearch::repository
    }

    if $opensearch::version !~ Undef and $opensearch::pin_package {
      case $facts['os']['family'] {
        'Debian': {
          include apt

          apt::pin { 'opensearch':
            version  => $opensearch::version,
            packages => 'opensearch',
            priority => $opensearch::apt_pin_priority,
            before   => Exec['install opensearch with initial admin password'],
          }
        }
        'RedHat': {
          include yum

          yum::versionlock { 'opensearch':
            version => $opensearch::version,
            before  => Exec['install opensearch with initial admin password'],
          }
        }
        default: {
          fail('Package pinning is not available for your OS!')
        }
      }
    }

    $admin_password = extlib::cache_data('opensearch_cache_data', 'admin_password', extlib::random_password(32))

    case $facts['os']['family'] {
      'Debian': {
        $command_install = 'apt-get -y install opensearch'
        $command_onlyif = "! dpkg-query -W -f='\${Status}' opensearch 2>/dev/null | grep -q 'install ok installed'"
      }
      'RedHat': {
        $command_install = 'yum -y install opensearch'
        $command_onlyif = '! rpm -q opensearch'
      }
      default: {
        fail('Package pinning is not available for your OS!')
      }
    }

    exec { 'install opensearch with initial admin password':
      command     => $command_install,
      onlyif      => $command_onlyif,
      environment => ["OPENSEARCH_INITIAL_ADMIN_PASSWORD=${admin_password}"],
      provider    => 'shell',
      before      => Package['opensearch'],
      require     => Class['opensearch::repository'],
    }
  }

  package { 'opensearch':
    ensure   => $ensure,
    provider => $provider,
    source   => $source,
  }
}
