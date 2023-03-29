# @summary
#   Handle opensearch repository.
#
# @api private
#
class opensearch::install::repository {
  assert_private()

  case $facts['os']['family'] {
    'RedHat': {
      contain opensearch::install::repository::redhat
    }
    'Debian': {
      contain opensearch::install::repository::debian
    }
    default: {
      fail("Your OS ${facts['os']['family']} (${facts['os']['name']}) is not supported to use a repository for installing opensearch!")
    }
  }
}
