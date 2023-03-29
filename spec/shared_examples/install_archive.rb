# frozen_string_literal: true

shared_examples 'install_archive' do |parameter, _facts|
  it {
    is_expected.to contain_class('opensearch::install::archive')
  }

  file = "opensearch-#{parameter['version']}-linux-#{parameter['package_architecture']}.tar.gz"

  it {
    is_expected.to contain_user('opensearch').with(
      {
        'ensure'     => parameter['package_ensure'],
        'home'       => parameter['package_directory'],
        'managehome' => false,
        'system'     => true,
        'shell'      => '/bin/false',
      }
    )
  }

  if parameter['package_ensure'] == 'present'
    it {
      is_expected.to contain_file(parameter['package_directory']).with(
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
          'extract_path'    => parameter['package_directory'],
          'extract_command' => "tar -xvzf /tmp/#{file} --wildcards opensearch-#{parameter['version']}/* -C #{parameter['package_directory']}",
          'user'            => 'opensearch',
          'group'           => 'opensearch',
          'creates'         => "#{parameter['package_directory']}/bin",
          'cleanup'         => true,
          'source'          => "https://artifacts.opensearch.org/releases/bundle/opensearch/#{parameter['version']}/#{file}",
        }
      )
    }
  else
    it {
      is_expected.to contain_file(parameter['package_directory']).with(
        {
          'ensure'  => parameter['package_ensure'],
          'revsere' => true,
          'force'   => true,
        }
      )
    }

    it {
      is_expected.to contain_file('/var/lib/opensearch').with(
        {
          'ensure'  => parameter['package_ensure'],
          'revsere' => true,
          'force'   => true,
        }
      )
    }

    it {
      is_expected.to contain_file('/var/log/opensearch').with(
        {
          'ensure'  => parameter['package_ensure'],
          'revsere' => true,
          'force'   => true,
        }
      )
    }
  end
end
