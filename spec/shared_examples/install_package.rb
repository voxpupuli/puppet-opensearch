# frozen_string_literal: true

shared_examples 'install_package' do |parameter, facts|
  it {
    is_expected.to contain_class('opensearch::install::package')
  }

  if parameter['package_source'] == 'download'
    ensure_value = parameter['package_ensure']
    provider = parameter['package_provider']

    file = case parameter['package_provider']
           when 'dpkg'
             "opensearch-#{parameter['version']}-linux-#{parameter['package_architecture']}.deb"
           when 'rpm'
             "opensearch-#{parameter['version']}-linux-#{parameter['package_architecture']}.rpm"
           end

    source = "/tmp/#{file}"

    it {
      is_expected.to contain_archive("/tmp/#{file}").with(
        {
          'provider' => 'wget',
          'extract'  => false,
          'cleanup'  => true,
          'source'   => "https://artifacts.opensearch.org/releases/bundle/opensearch/#{parameter['version']}/#{file}",
        }
      ).that_comes_before('Package[opensearch]')
    }
  else
    ensure_value = if parameter['version'] == :undef
                     parameter['package_ensure']
                   else
                     parameter['version']
                   end
    provider = nil
    source = nil

    include_examples 'repository', parameter, facts if parameter['manage_repository']

    if (parameter['version'] != :undef) && parameter['pin_package']
      case facts[:os]['family']
      when 'Debian'
        it {
          is_expected.to contain_apt__pin('opensearch').with(
            {
              'version'  => parameter['version'],
              'packages' => 'opensearch',
              'priority' => parameter['apt_pin_priority'],
            }
          )
        }
      when 'RedHat'
        it {
          is_expected.to contain_yum__versionlock('opensearch').with(
            {
              'version' => parameter['version'],
            }
          )
        }
      end
    end
  end

  it {
    is_expected.to contain_exec('set_initial_password_environment').with(
      {
        'command' => "env OPENSEARCH_INITIAL_ADMIN_PASSWORD=#{parameter['initial_admin_password']}"
      }
    )
  }

  it {
    is_expected.to contain_package('opensearch').with(
      {
        'ensure'   => ensure_value,
        'provider' => provider,
        'source'   => source,
      }
    ).that_requires('Exec[set_initial_password_environment]')
  }
end
