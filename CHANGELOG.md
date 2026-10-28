# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v2.1.0](https://github.com/voxpupuli/puppet-opensearch/tree/v2.1.0) (2026-10-28)

[Full Changelog](https://github.com/voxpupuli/puppet-opensearch/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- puppet/systemd: Allow 11.x [\#88](https://github.com/voxpupuli/puppet-opensearch/pull/88) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/puppet-opensearch/tree/v2.0.0) (2026-10-13)

[Full Changelog](https://github.com/voxpupuli/puppet-opensearch/compare/v1.1.0...v2.0.0)

**Breaking changes:**

- Drop puppet, update openvox minimum version to 8.19 [\#63](https://github.com/voxpupuli/puppet-opensearch/pull/63) ([TheMeier](https://github.com/TheMeier))

**Implemented enhancements:**

- Add EL9 support [\#83](https://github.com/voxpupuli/puppet-opensearch/pull/83) ([bastelfreak](https://github.com/bastelfreak))
- Add Ubuntu 24.04 & 26.04 support [\#82](https://github.com/voxpupuli/puppet-opensearch/pull/82) ([bastelfreak](https://github.com/bastelfreak))
- Add workaround for initial admin password [\#81](https://github.com/voxpupuli/puppet-opensearch/pull/81) ([bastelfreak](https://github.com/bastelfreak))
- Update module dependencies [\#79](https://github.com/voxpupuli/puppet-opensearch/pull/79) ([teluq-pbrideau](https://github.com/teluq-pbrideau))
- Add parameters in jvm.options [\#78](https://github.com/voxpupuli/puppet-opensearch/pull/78) ([teluq-pbrideau](https://github.com/teluq-pbrideau))
- Update requirements to allow OpenVox 9 [\#75](https://github.com/voxpupuli/puppet-opensearch/pull/75) ([sebastianrakel](https://github.com/sebastianrakel))
- support opensearch 3.x [\#73](https://github.com/voxpupuli/puppet-opensearch/pull/73) ([bugfood](https://github.com/bugfood))
- Add support for Debian 12 [\#65](https://github.com/voxpupuli/puppet-opensearch/pull/65) ([smortex](https://github.com/smortex))
- Make OOM heap dump configurable [\#64](https://github.com/voxpupuli/puppet-opensearch/pull/64) ([lemkep](https://github.com/lemkep))
- puppetlabs/apt Allow 10.x, puppet/archive Allow 8.x [\#62](https://github.com/voxpupuli/puppet-opensearch/pull/62) ([TheMeier](https://github.com/TheMeier))
- puppet systemd 9 [\#56](https://github.com/voxpupuli/puppet-opensearch/pull/56) ([jay7x](https://github.com/jay7x))
- puppetlabs/systemd: Allow 6.x [\#50](https://github.com/voxpupuli/puppet-opensearch/pull/50) ([zilchms](https://github.com/zilchms))
- add jvm\_gc\_config and jvm\_gc\_logging\_config parameter [\#47](https://github.com/voxpupuli/puppet-opensearch/pull/47) ([crazymind1337](https://github.com/crazymind1337))

**Fixed bugs:**

- disable Java security manager [\#87](https://github.com/voxpupuli/puppet-opensearch/pull/87) ([bastelfreak](https://github.com/bastelfreak))
- Fix typo in documentation [\#85](https://github.com/voxpupuli/puppet-opensearch/pull/85) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Non-parametrized config in JVM settings [\#77](https://github.com/voxpupuli/puppet-opensearch/issues/77)
- Opensearch 3 support [\#68](https://github.com/voxpupuli/puppet-opensearch/issues/68)
- Install fails, Unknown function: 'stdlib::to\_yaml' [\#40](https://github.com/voxpupuli/puppet-opensearch/issues/40)

**Merged pull requests:**

- Add a name to the yum repository [\#41](https://github.com/voxpupuli/puppet-opensearch/pull/41) ([smortex](https://github.com/smortex))

## [v1.1.0](https://github.com/voxpupuli/puppet-opensearch/tree/v1.1.0) (2023-08-03)

[Full Changelog](https://github.com/voxpupuli/puppet-opensearch/compare/v1.0.0...v1.1.0)

**Implemented enhancements:**

- Add support for managing more configuration files [\#35](https://github.com/voxpupuli/puppet-opensearch/pull/35) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- Fix installation from archive [\#37](https://github.com/voxpupuli/puppet-opensearch/pull/37) ([smortex](https://github.com/smortex))
- Fix files recurse parameter when ensure =\> absent [\#36](https://github.com/voxpupuli/puppet-opensearch/pull/36) ([smortex](https://github.com/smortex))

**Closed issues:**

- Figure out how to handle opensearch-dashboards [\#20](https://github.com/voxpupuli/puppet-opensearch/issues/20)

## [v1.0.0](https://github.com/voxpupuli/puppet-opensearch/tree/v1.0.0) (2023-06-16)

[Full Changelog](https://github.com/voxpupuli/puppet-opensearch/compare/v0.3.0...v1.0.0)

**Breaking changes:**

- Require stdlib 9.x [\#32](https://github.com/voxpupuli/puppet-opensearch/pull/32) ([bastelfreak](https://github.com/bastelfreak))
- Drop Puppet 6 [\#27](https://github.com/voxpupuli/puppet-opensearch/pull/27) ([smortex](https://github.com/smortex))

**Implemented enhancements:**

- If specific version specified, hold the package? [\#24](https://github.com/voxpupuli/puppet-opensearch/issues/24)
- Add Puppet 8 support [\#31](https://github.com/voxpupuli/puppet-opensearch/pull/31) ([bastelfreak](https://github.com/bastelfreak))
- Relax dependencies version requirements [\#29](https://github.com/voxpupuli/puppet-opensearch/pull/29) ([smortex](https://github.com/smortex))
- Add package pinning/versionlock [\#25](https://github.com/voxpupuli/puppet-opensearch/pull/25) ([crazymind1337](https://github.com/crazymind1337))

**Merged pull requests:**

- purge pdk settings from metadata.json [\#30](https://github.com/voxpupuli/puppet-opensearch/pull/30) ([bastelfreak](https://github.com/bastelfreak))

## [v0.3.0](https://github.com/voxpupuli/puppet-opensearch/tree/v0.3.0) (2023-03-31)

[Full Changelog](https://github.com/voxpupuli/puppet-opensearch/compare/v0.2.0...v0.3.0)

**Breaking changes:**

- Refactor repository handling [\#17](https://github.com/voxpupuli/puppet-opensearch/pull/17) ([crazymind1337](https://github.com/crazymind1337))

**Implemented enhancements:**

- Switch to module hiera data values [\#21](https://github.com/voxpupuli/puppet-opensearch/pull/21) ([crazymind1337](https://github.com/crazymind1337))
- Do not use parameters for private classes [\#14](https://github.com/voxpupuli/puppet-opensearch/pull/14) ([smortex](https://github.com/smortex))
- Add Debian repository handling [\#12](https://github.com/voxpupuli/puppet-opensearch/pull/12) ([crazymind1337](https://github.com/crazymind1337))

**Fixed bugs:**

- Fixes apt-get update to be executed before package installation [\#19](https://github.com/voxpupuli/puppet-opensearch/pull/19) ([crazymind1337](https://github.com/crazymind1337))

**Closed issues:**

- Package is installed before apt-get update [\#18](https://github.com/voxpupuli/puppet-opensearch/issues/18)
- Use module hiera data instead of params.pp [\#16](https://github.com/voxpupuli/puppet-opensearch/issues/16)
- Using the repository will only install the current latest package version [\#15](https://github.com/voxpupuli/puppet-opensearch/issues/15)

**Merged pull requests:**

- Add Debian 11 to supported OSes [\#13](https://github.com/voxpupuli/puppet-opensearch/pull/13) ([crazymind1337](https://github.com/crazymind1337))

## [v0.2.0](https://github.com/voxpupuli/puppet-opensearch/tree/v0.2.0) (2023-03-23)

[Full Changelog](https://github.com/voxpupuli/puppet-opensearch/compare/v0.1.0...v0.2.0)

**Implemented enhancements:**

- cleanup metadata.json; add missing source key [\#9](https://github.com/voxpupuli/puppet-opensearch/pull/9) ([crazymind1337](https://github.com/crazymind1337))

## [v0.1.0](https://github.com/voxpupuli/puppet-opensearch/tree/v0.1.0) (2023-03-23)

[Full Changelog](https://github.com/voxpupuli/puppet-opensearch/compare/e63db5e765ce5eeb6b5f71a833dee62028ece54f...v0.1.0)

**Merged pull requests:**

- update README.md and use latest repositories for depending modules in rspec tests [\#7](https://github.com/voxpupuli/puppet-opensearch/pull/7) ([crazymind1337](https://github.com/crazymind1337))
- Add beaker tests; add missing dependencies to metadata.json [\#6](https://github.com/voxpupuli/puppet-opensearch/pull/6) ([crazymind1337](https://github.com/crazymind1337))
- add rspec tests with fixes for manifests [\#5](https://github.com/voxpupuli/puppet-opensearch/pull/5) ([crazymind1337](https://github.com/crazymind1337))
- fix lint issues [\#4](https://github.com/voxpupuli/puppet-opensearch/pull/4) ([crazymind1337](https://github.com/crazymind1337))
- set a correct license in metadata [\#3](https://github.com/voxpupuli/puppet-opensearch/pull/3) ([crazymind1337](https://github.com/crazymind1337))
- modulesync for puppet-opensearch [\#2](https://github.com/voxpupuli/puppet-opensearch/pull/2) ([crazymind1337](https://github.com/crazymind1337))
- first stage of a working module [\#1](https://github.com/voxpupuli/puppet-opensearch/pull/1) ([crazymind1337](https://github.com/crazymind1337))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
