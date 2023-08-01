# frozen_string_literal: true

shared_examples 'service' do |parameter, _facts|
  it {
    is_expected.to contain_class('opensearch::service')
  }

  if parameter['manage_service']
    if parameter['package_source'] == 'archive'
      it {
        is_expected.to contain_systemd__unit_file('opensearch.service').with(
          {
            'ensure' => 'present',
            'content' => %r{ExecStart=/opt/opensearch/bin/opensearch},
          }
        )
      }
    end

    it {
      is_expected.to contain_service('opensearch').with(
        {
          'ensure' => parameter['service_ensure'],
          'enable' => parameter['service_enable'],
        }
      )
    }
  end
end
