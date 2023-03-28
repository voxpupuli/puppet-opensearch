# @summary
#   Configure opensearch.
#
# @api private
#
class opensearch::config {
  assert_private()

  if $opensearch::manage_config {
    $config_directory = $opensearch::package_install_method ? {
      'archive' => "${opensearch::package_directory}/config",
      default   => '/etc/opensearch',
    }

    $settings = $opensearch::use_default_settings ? {
      true  => merge($opensearch::default_settings, $opensearch::settings),
      false => $opensearch::settings,
    }

    file { "${config_directory}/opensearch.yml":
      ensure  => file,
      owner   => 'opensearch',
      group   => 'opensearch',
      mode    => '0640',
      content => $settings.to_yaml,
    }

    file { "${config_directory}/jvm.options":
      ensure  => file,
      owner   => 'opensearch',
      group   => 'opensearch',
      mode    => '0640',
      content => epp("${module_name}/jvm.options.epp",
        {
          heap_size  => $opensearch::heap_size,
        }
      ),
    }
  }
}
