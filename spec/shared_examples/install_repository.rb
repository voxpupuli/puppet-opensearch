# frozen_string_literal: true

shared_examples 'install_repository' do |parameter, facts|
  case facts[:os]['family']
  when 'RedHat'
    it {
      is_expected.to contain_class('opensearch::install::repository')
    }

    include_examples 'install_repository_redhat', parameter, facts
  end
end
