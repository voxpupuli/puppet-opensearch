# @summary
#   Configure opensearch.
#
# @api private
#
class opensearch::config (
  ##
  ## opensearch settings
  ##
  $manage_config        = $opensearch::manage_config,
  $use_default_settings = $opensearch::use_default_settings,
  $default_settings     = $opensearch::default_settings,
  $settings             = $opensearch::settings,

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

    if $use_default_settings {
      $data = merge($default_settings, $settings)
    } else {
      $data = $settings
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
