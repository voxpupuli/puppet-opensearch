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

    default_jvm_gc_settings = if parameter.key?('use_default_jvm_gc_settings') && parameter['use_default_jvm_gc_settings']
                                [
                                  '8-10:-XX:+UseConcMarkSweepGC',
                                  '8-10:-XX:CMSInitiatingOccupancyFraction=75',
                                  '8-10:-XX:+UseCMSInitiatingOccupancyOnly',
                                  '11-:-XX:+UseG1GC',
                                  '11-:-XX:G1ReservePercent=25',
                                  '11-:-XX:InitiatingHeapOccupancyPercent=30',
                                ]
                              else
                                []
                              end

    default_jvm_gc_logging_settings = if parameter.key?('use_default_jvm_gc_logging_settings') && parameter['use_default_jvm_gc_logging_settings']
                                        [
                                          '8:-XX:+PrintGCDetails',
                                          '8:-XX:+PrintGCDateStamps',
                                          '8:-XX:+PrintTenuringDistribution',
                                          '8:-XX:+PrintGCApplicationStoppedTime',
                                          '8:-Xloggc:/var/log/opensearch/gc.log',
                                          '8:-XX:+UseGCLogFileRotation',
                                          '8:-XX:NumberOfGCLogFiles=32',
                                          '8:-XX:GCLogFileSize=64m',
                                          '9-:-Xlog:gc*,gc+age=trace,safepoint:file=/var/log/opensearch/gc.log:utctime,pid,tags:filecount=32,filesize=64m',
                                        ]
                                      else
                                        []
                                      end

    jvm_gc_settings = if parameter.key?('jvm_gc_settings') && parameter['jvm_gc_settings']
                        parameter['jvm_gc_settings']
                      else
                        []
                      end

    jvm_gc_logging_settings = if parameter.key?('jvm_gc_logging_settings') && parameter['jvm_gc_logging_settings']
                                parameter['jvm_gc_logging_settings']
                              else
                                []
                              end

    [
      default_jvm_gc_settings,
      default_jvm_gc_logging_settings,
      jvm_gc_settings,
      jvm_gc_logging_settings
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
