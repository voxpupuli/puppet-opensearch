# frozen_string_literal: true

shared_examples 'install_repository_debian' do |parameter, _facts|
  it {
    is_expected.to contain_class('opensearch::install::repository::debian')
  }

  ensure_value = parameter['package_ensure']

  it {
    is_expected.to contain_archive('/tmp/opensearch.pgp').with(
      {
        'ensure'          => ensure_value,
        'source'          => 'https://artifacts.opensearch.org/publickeys/opensearch.pgp',
        'extract'         => true,
        'extract_path'    => '/usr/share/keyrings',
        'extract_command' => 'gpg --dearmor < %s > opensearch.keyring.gpg',
        'creates'         => '/usr/share/keyrings/opensearch.keyring.gpg',
      }
    ).that_comes_before('Apt::Source[opensearch]')
  }

  it {
    is_expected.to contain_apt__source('opensearch').with(
      {
        'ensure'   => ensure_value,
        'location' => 'https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/apt',
        'release'  => 'stable',
        'repos'    => 'main',
        'keyring'  => '/usr/share/keyrings/opensearch.keyring.gpg',
      }
    ).that_notifies('Class[apt::update]')
  }

  it {
    is_expected.to contain_package('opensearch').with(
      {
        'ensure' => ensure_value,
      }
    )
  }
end
