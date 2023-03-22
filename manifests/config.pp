# @summary
#   Configure opensearch.
#
# @api private
#
class opensearch::config (
  ##
  ## opensearch settings
  ##
  $default_settings     = $opensearch::default_settings,
  $settings             = $opensearch::settings,
  $use_default_settings = $opensearch::use_default_settings,

  ##
  ## java settings
  ##
  $heap_size            = $opensearch::heap_size,
) {
  assert_private()

  if $opensearch::manage_config {
    $config_directory = $opensearch::package_install_method ? {
      'archive' => "${opensearch::package_directory}/config",
      default   => '/etc/opensearch',
    }

    $data = $use_default_settings ? {
      true  => merge($default_settings, $settings),
      false => $settings,
    }

    file { "${config_directory}/opensearch.yml":
      ensure  => file,
      owner   => 'opensearch',
      group   => 'opensearch',
      mode    => '0640',
      content => $data.to_yaml,
    }

    file { "${config_directory}/jvm.options":
      ensure  => file,
      owner   => 'opensearch',
      group   => 'opensearch',
      mode    => '0640',
      content => epp("${module_name}/jvm.options.epp",
        {
          heap_size  => $heap_size,
        }
      ),
    }
  }
}
