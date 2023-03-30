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
  end

  it {
    is_expected.to contain_package('opensearch').with(
      {
        'ensure'   => ensure_value,
        'provider' => provider,
        'source'   => source,
      }
    )
  }
end
