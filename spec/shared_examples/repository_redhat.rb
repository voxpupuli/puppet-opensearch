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
              "https://artifacts.opensearch.org/releases/bundle/opensearch/#{parameter['version'].to_s[0]}.x/yum"
            else
              parameter['repository_location']
            end
  key_version = if parameter['version'] && (parameter['version'].to_s[0] == '3')
                  '3'
                else
                  '2'
                end
  it {
    is_expected.to contain_yumrepo('opensearch').with(
      {
        'ensure'        => parameter['repository_ensure'],
        'baseurl'       => baseurl,
        'repo_gpgcheck' => '1',
        'gpgcheck'      => '1',
        'gpgkey'        => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-opensearch-#{key_version}",
      },
    ).that_requires("File[/etc/pki/rpm-gpg/RPM-GPG-KEY-opensearch-#{key_version}]")
  }

  it {
    is_expected.to contain_file("/etc/pki/rpm-gpg/RPM-GPG-KEY-opensearch-#{key_version}").with(
      'ensure' => parameter['repository_ensure'],
      'source' => "puppet:///modules/opensearch/opensearch-#{key_version}.asc",
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    )
  }
end
