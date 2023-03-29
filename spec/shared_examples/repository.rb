# frozen_string_literal: true

shared_examples 'repository' do |parameter, facts|
  it {
    is_expected.to contain_class('opensearch::repository')
  }

  case facts[:os]['family']
  when 'RedHat'
    include_examples 'repository_redhat', parameter, facts
  when 'Debian'
    include_examples 'repository_debian', parameter, facts
  end
end
