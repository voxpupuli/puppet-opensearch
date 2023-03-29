# frozen_string_literal: true

shared_examples 'config' do |parameter, _facts|
  it {
    is_expected.to contain_class('opensearch::config').that_comes_before('Class[opensearch::service]')
  }

  if parameter['restart_on_config_change']
    it {
      is_expected.to contain_class('opensearch::config').that_notifies('Class[openSearch::service]')
    }
  end

  if parameter['manage_config']
    config_directory = case parameter['package_install_method']
                       when 'archive'
                         "#{parameter['package_directory']}/config"
                       else
                         '/etc/opensearch'
                       end

    settings = if parameter['use_default_settings']
                 parameter['default_settings'].merge(parameter['settings'])
               else
                 parameter['settings']
               end

    require 'yaml'

    it {
      is_expected.to contain_file("#{config_directory}/opensearch.yml").with(
        {
          'ensure'  => 'file',
          'owner'   => 'opensearch',
          'group'   => 'opensearch',
          'mode'    => '0640',
          'content' => settings.to_yaml,
        }
      )
    }

    it {
      is_expected.to contain_file("#{config_directory}/jvm.options").with(
        {
          'ensure'  => 'file',
          'owner'   => 'opensearch',
          'group'   => 'opensearch',
          'mode'    => '0640',
          'content' => %r{-Xms#{parameter['heap_size']}},
        }
      )
    }
  end
end
