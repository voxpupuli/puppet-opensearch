# frozen_string_literal: true

shared_examples 'install_repository' do |parameter, facts|
  it {
    is_expected.to contain_class('opensearch::install::repository')
  }

  case facts[:os]['family']
  when 'RedHat'
    include_examples 'install_repository_redhat', parameter, facts
  when 'Debian'
    include_examples 'install_repository_debian', parameter, facts
  end
end
