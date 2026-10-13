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

  key_version = if parameter['version'] && (parameter['version'] == '3.9.0')
                  '3'
                   else
                     '2'
                   end
  it {
    is_expected.to contain_apt__source('opensearch').with(
      {
        'ensure'   => parameter['repository_ensure'],
        'location' => location,
        'release'  => 'stable',
        'repos'    => 'main',
        'key'      => {
          'name'   => "opensearch-#{key_version}.asc",
          'source' => "puppet:///modules/opensearch/opensearch-#{key_version}.asc",
        },
      },
    ).that_notifies('Exec[apt_update]')
  }
end
