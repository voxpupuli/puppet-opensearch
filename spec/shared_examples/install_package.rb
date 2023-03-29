# frozen_string_literal: true

shared_examples 'install_package' do |parameter, _facts|
  it {
    is_expected.to contain_class('opensearch::install::package')
  }

  file = case parameter['package_provider']
         when 'dpkg'
           "opensearch-#{parameter['version']}-linux-#{parameter['package_architecture']}.deb"
         when 'rpm'
           "opensearch-#{parameter['version']}-linux-#{parameter['package_architecture']}.rpm"
         end

  it {
    is_expected.to contain_archive("/tmp/#{file}").with(
      {
        'provider' => 'wget',
        'extract'  => false,
        'cleanup'  => true,
        'source'   => "https://artifacts.opensearch.org/releases/bundle/opensearch/#{parameter['version']}/#{file}",
      }
    )
  }

  it {
    is_expected.to contain_package('opensearch').with(
      {
        'ensure'   => parameter['package_ensure'],
        'provider' => parameter['package_provider'],
        'source'   => "/tmp/#{file}",
      }
    )
  }
end
