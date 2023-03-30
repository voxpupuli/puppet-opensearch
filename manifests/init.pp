# @summary
#   Module to manage opensearch.
#
# @param version
#   The version to be installed. See also: https://opensearch.org/downloads.html
#
# @param manage_package
#   Whether to manage the package installation-
# @param package_source
#   The source for the package.
# @param package_ensure
#   The status of the package.
# @param package_architecture
#   The architecture for the package.
# @param package_provider
#   The provider for the package to be used to install the package.
# @param package_directory
#   The directory to install the package. Only used for package_install_method = 'archive'.
#
# @param manage_config
#   Whether to manage the configuration.
# @param use_default_settings
#   Whether to use the modules default settings values.
# @param default_settings
#   The modules default settings for opensearch.
# @param settings
#   Additional settings for opensearch.
#
# @param heap_size
#   The heap size for the JVM.
#
# @param manage_service
#   Whether to manage the opensearch service.
# @param service_ensure
#   The state for the opensearch service.
# @param service_enable
#   Whether to enable the service.
# @param restart_on_config_change
#   Restart the service on any config changes
# @param restart_on_package_change
#   Restart the service on package changes
#
class opensearch (
  ##
  ## version
  ##
  Optional[String]                          $version                   = undef,

  ##
  ## package values
  ##
  Boolean                                   $manage_package            = true,
  Enum['x64', 'arm64']                      $package_architecture      = $opensearch::params::package_architecture,
  Stdlib::Absolutepath                      $package_directory         = '/opt/opensearch',
  Enum['present', 'absent']                 $package_ensure            = 'present',
  Enum['dpkg', 'rpm']                       $package_provider          = $opensearch::params::package_provider,
  Enum['archive', 'download', 'repository'] $package_source            = 'repository',

  ##
  ## repository
  ##
  Boolean                                   $manage_repository         = true,
  Enum['present', 'absent']                 $repository_ensure         = 'present',
  Optional[Stdlib::HTTPUrl]                 $repository_location       = undef,
  Stdlib::HTTPUrl                           $repository_gpg_key        = 'https://artifacts.opensearch.org/publickeys/opensearch.pgp',

  ##
  ## opensearch settings
  ##
  Boolean                                   $manage_config             = true,
  Boolean                                   $use_default_settings      = true,
  Hash                                      $default_settings          = $opensearch::params::default_settings,
  Hash                                      $settings                  = {},

  ##
  ## java settings
  ##
  Pattern[/\d+[mg]/]                        $heap_size                 = '512m',

  ##
  ## service values
  ##
  Boolean                                   $manage_service            = true,
  Stdlib::Ensure::Service                   $service_ensure            = 'running',
  Boolean                                   $service_enable            = true,
  Boolean                                   $restart_on_config_change  = true,
  Boolean                                   $restart_on_package_change = true,
) inherits opensearch::params {
  contain opensearch::install
  contain opensearch::config
  contain opensearch::service

  Class['opensearch::install'] -> Class['opensearch::config'] -> Class['opensearch::service']

  if $restart_on_package_change {
    Class['opensearch::install'] ~> Class['opensearch::service']
  }

  if $restart_on_config_change {
    Class['opensearch::config'] ~> Class['opensearch::service']
  }
}
