# @summary
#   Install opensearch via tarball.
#
# @api private
#
class opensearch::install::archive (
  $version      = $opensearch::version,
  $ensure       = $opensearch::package_ensure,
  $architecture = $opensearch::package_architecture,
  $directory    = $opensearch::package_directory,
) {
  assert_private()

  $file = "opensearch-${version}-linux-${architecture}.tar.gz"

  user { 'opensearch':
    ensure     => $ensure,
    home       => $directory,
    managehome => false,
    system     => true,
    shell      => '/bin/false',
  }

  if $ensure == 'present' {
    file { $directory:
      ensure => 'directory',
      owner  => 'opensearch',
      group  => 'opensearch',
    }

    file { '/var/lib/opensearch':
      ensure => 'directory',
      owner  => 'opensearch',
      group  => 'opensearch',
    }

    file { '/var/log/opensearch':
      ensure => 'directory',
      owner  => 'opensearch',
      group  => 'opensearch',
    }

    archive { "/tmp/opensearch-${version}-linux-x64.tar.gz":
      provider        => 'wget',
      path            => "/tmp/${file}",
      extract         => true,
      extract_path    => $directory,
      extract_command => "tar -xvzf /tmp/${file} --wildcards opensearch-${version}/* -C ${directory}",
      user            => 'opensearch',
      group           => 'opensearch',
      creates         => "${directory}/bin",
      cleanup         => true,
      source          => "https://artifacts.opensearch.org/releases/bundle/opensearch/${version}/${file}",
    }
  } else {
    file { $directory:
      ensure  => $ensure,
      revsere => true,
      force   => true,
    }

    file { '/var/lib/opensearch':
      ensure  => $ensure,
      revsere => true,
      force   => true,
    }

    file { '/var/log/opensearch':
      ensure  => $ensure,
      revsere => true,
      force   => true,
    }
  }
}
