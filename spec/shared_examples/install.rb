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

  if parameter['manage_package']
    if parameter['package_source'] == 'archive'
      include_examples 'install_archive', parameter
    else
      include_examples 'install_package', parameter, facts
    end
  end
end
