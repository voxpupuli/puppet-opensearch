# frozen_string_literal: true

shared_examples 'install_repository_redhat' do |parameter, _facts|
  it {
    is_expected.to contain_class('opensearch::install::repository::redhat')
  }

  it {
    is_expected.to contain_yumrepo('OpenSearch 2.x').with(
      {
        'ensure'        => parameter['package_ensure'],
        'baseurl'       => 'https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/yum',
        'repo_gpgcheck' => '1',
        'gpgcheck'      => '1',
        'gpgkey'        => 'https://artifacts.opensearch.org/publickeys/opensearch.pgp',
      }
    ).that_comes_before('Package[opensearch]')
  }

  it {
    is_expected.to contain_package('opensearch').with(
      {
        'ensure' => parameter['package_ensure'],
      }
    )
  }
end
