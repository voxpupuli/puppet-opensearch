# @summary
#   Handle opensearch service.
#
# @api private
#
class opensearch::service (
) {
  assert_private()

  if $opensearch::manage_service {
    if $opensearch::package_install_method == 'archive' {
      systemd::unit_file { 'opensearch.service':
        ensure => 'present',
        source => "puppet:///modules/${module_name}/opensearch.service",
      }
    }

    service { 'opensearch':
      ensure => $opensearch::service_ensure,
      enable => $opensearch::service_enable,
    }
  }
}
