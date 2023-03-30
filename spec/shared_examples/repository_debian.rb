# frozen_string_literal: true

shared_examples 'repository_debian' do |parameter|
  it {
    is_expected.to contain_class('opensearch::repository::debian')
  }

  location = if parameter['version'] == :undef
               if parameter['repository_location'] == :undef
                 'https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/apt'
               else
                 parameter['repository_location']
               end
             elsif parameter['repository_location'] == :undef
               "https://artifacts.opensearch.org/releases/bundle/opensearch/#{parameter['version'][0]}.x/apt"
             else
               parameter['repository_location']
             end

  it {
    is_expected.to contain_archive('/tmp/opensearch.pgp').with(
      {
        'ensure'          => parameter['repository_ensure'],
        'source'          => parameter['repository_gpg_key'],
        'extract'         => true,
        'extract_path'    => '/usr/share/keyrings',
        'extract_command' => 'gpg --dearmor < %s > opensearch.keyring.gpg',
        'creates'         => '/usr/share/keyrings/opensearch.keyring.gpg',
      }
    )
  }

  it {
    is_expected.to contain_apt__source('opensearch').with(
      {
        'ensure'   => parameter['repository_ensure'],
        'location' => location,
        'release'  => 'stable',
        'repos'    => 'main',
        'keyring'  => '/usr/share/keyrings/opensearch.keyring.gpg',
      }
    ).that_notifies('Class[apt::update]')
  }
end
