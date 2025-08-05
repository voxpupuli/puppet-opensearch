# frozen_string_literal: true

shared_examples 'config' do |parameter|
  it {
    is_expected.to contain_class('opensearch::config').that_comes_before('Class[opensearch::service]')
  }

  if parameter['restart_on_config_change']
    it {
      is_expected.to contain_class('opensearch::config').that_notifies('Class[openSearch::service]')
    }
  end

  if parameter['manage_config']
    config_directory = case parameter['package_source']
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
          'mode'    => '0644',
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
          'mode'    => '0644',
          'content' => %r{-Xms#{parameter['heap_size']}},
        }
      )
    }

    default_jvm_gc_settings = if parameter['use_default_jvm_gc_settings']
                                parameter['default_jvm_gc_settings']
                              else
                                []
                              end

    default_jvm_gc_logging_settings = if parameter['use_default_jvm_gc_logging_settings']
                                        parameter['default_jvm_gc_logging_settings']
                                      else
                                        []
                                      end

    [
      default_jvm_gc_settings,
      default_jvm_gc_logging_settings,
      parameter['jvm_gc_settings'],
      parameter['jvm_gc_logging_settings']
    ].flatten.each do |setting|
      match = setting.gsub(%r{([+*])}, '\\\\\\1')

      it {
        is_expected.to contain_file("#{config_directory}/jvm.options").with(
          {
            'content' => %r{#{match}},
          }
        )
      }
    end
  end
end
