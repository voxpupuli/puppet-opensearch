# frozen_string_literal: true

shared_examples 'repository_redhat' do |parameter|
  it {
    is_expected.to contain_class('opensearch::repository::redhat')
  }

  baseurl = if parameter['version'] == :undef
              if parameter['repository_location'] == :undef
                'https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/yum'
              else
                parameter['repository_location']
              end
            elsif parameter['repository_location'] == :undef
              "https://artifacts.opensearch.org/releases/bundle/opensearch/#{parameter['version'][0]}.x/yum"
            else
              parameter['repository_location']
            end

  it {
    is_expected.to contain_yumrepo('opensearch').with(
      {
        'ensure'        => parameter['repository_ensure'],
        'baseurl'       => baseurl,
        'repo_gpgcheck' => '1',
        'gpgcheck'      => '1',
        'gpgkey'        => 'https://artifacts.opensearch.org/publickeys/opensearch.pgp',
      }
    )
  }
end
