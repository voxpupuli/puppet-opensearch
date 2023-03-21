# @summary
#   Installs opensearch via archive, package, or repository.
#
# @api private
#
class opensearch::install (
) {
  assert_private()

  if $opensearch::manage_package {
    contain "opensearch::install::${opensearch::package_install_method}"
  }
}
