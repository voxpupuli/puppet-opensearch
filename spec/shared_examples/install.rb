# frozen_string_literal: true

shared_examples 'install' do |parameter, facts|
  it {
    is_expected.to contain_class('opensearch::install').that_comes_before('Class[opensearch::config]')
  }

  if parameter['restart_on_package_change']
    it {
      is_expected.to contain_class('opensearch::install').that_notifies('Class[openSearch::service]')
    }
  end

  include_examples "install_#{parameter['package_install_method']}", parameter, facts if parameter['manage_package']
end
