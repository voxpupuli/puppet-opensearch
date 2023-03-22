# frozen_string_literal: true

shared_examples 'install_archive' do |parameter, _facts|
  it {
    is_expected.to contain_class('opensearch::install::archive')
  }

  architecture = parameter['package_architecture']
  directory    = parameter['package_directory']
  ensure_value = parameter['package_ensure']
  version      = parameter['version']
  file         = "opensearch-#{version}-linux-#{architecture}.tar.gz"

  it {
    is_expected.to contain_user('opensearch').with(
      {
        'ensure'     => ensure_value,
        'home'       => directory,
        'managehome' => false,
        'system'     => true,
        'shell'      => '/bin/false',
      }
    )
  }

  if ensure_value == 'present'
    it {
      is_expected.to contain_file(directory).with(
        {
          'ensure' => 'directory',
          'owner'  => 'opensearch',
          'group'  => 'opensearch',
        }
      )
    }

    it {
      is_expected.to contain_file('/var/lib/opensearch').with(
        {
          'ensure' => 'directory',
          'owner'  => 'opensearch',
          'group'  => 'opensearch',
        }
      )
    }

    it {
      is_expected.to contain_file('/var/log/opensearch').with(
        {
          'ensure' => 'directory',
          'owner'  => 'opensearch',
          'group'  => 'opensearch',
        }
      )
    }

    it {
      is_expected.to contain_archive("/tmp/#{file}").with(
        {
          'provider'        => 'wget',
          'path'            => "/tmp/#{file}",
          'extract'         => true,
          'extract_path'    => directory,
          'extract_command' => "tar -xvzf /tmp/#{file} --wildcards opensearch-#{version}/* -C #{directory}",
          'user'            => 'opensearch',
          'group'           => 'opensearch',
          'creates'         => "#{directory}/bin",
          'cleanup'         => true,
          'source'          => "https://artifacts.opensearch.org/releases/bundle/opensearch/#{version}/#{file}",
        }
      )
    }
  else
    it {
      is_expected.to contain_file(directory).with(
        {
          'ensure'  => ensure_value,
          'revsere' => true,
          'force'   => true,
        }
      )
    }

    it {
      is_expected.to contain_file('/var/lib/opensearch').with(
        {
          'ensure'  => ensure_value,
          'revsere' => true,
          'force'   => true,
        }
      )
    }

    it {
      is_expected.to contain_file('/var/log/opensearch').with(
        {
          'ensure'  => ensure_value,
          'revsere' => true,
          'force'   => true,
        }
      )
    }
  end
end
