# frozen_string_literal: true

shared_examples 'install_package' do |parameter, _facts|
  it {
    is_expected.to contain_class('opensearch::install::package')
  }

  architecture = parameter['package_architecture']
  ensure_value = parameter['package_ensure']
  provider     = parameter['package_provider']
  version      = parameter['version']

  file = case provider
         when 'dpkg'
           "opensearch-#{version}-linux-#{architecture}.deb"
         when 'rpm'
           "opensearch-#{version}-linux-#{architecture}.rpm"
         end

  it {
    is_expected.to contain_archive("/tmp/#{file}").with(
      {
        'provider' => 'wget',
        'extract'  => false,
        'cleanup'  => true,
        'source'   => "https://artifacts.opensearch.org/releases/bundle/opensearch/#{version}/#{file}",
      }
    )
  }

  it {
    is_expected.to contain_package('opensearch').with(
      {
        'ensure'   => ensure_value,
        'provider' => provider,
        'source'   => "/tmp/#{file}",
      }
    )
  }
end
