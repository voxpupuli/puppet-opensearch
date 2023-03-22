# frozen_string_literal: true

def get_defaults(facts)
  package_architecture = case facts[:os]['architecture']
                         when %r{(amd64|x64|x86_64)}
                           'x64'
                         when 'arm64'
                           'arm64'
                         end

  package_provider = case facts[:os]['family']
                     when 'RedHat'
                       'rpm'
                     when 'Debian'
                       'dpkg'
                     end

  default_settings = {
    'cluster.name'                                                 => 'opensearch',
    'cluster.initial_cluster_manager_nodes'                        => facts[:networking]['hostname'],
    'discovery.seed_hosts'                                         => [
      '127.0.0.1',
    ],
    'gateway.recover_after_nodes'                                  => 0,
    'http.port'                                                    => 9200,
    'network.host'                                                 => '127.0.0.1',
    'node.max_local_storage_nodes'                                 => 3,
    'node.name'                                                    => facts[:networking]['hostname'],
    'path.data'                                                    => '/var/lib/opensearch',
    'path.logs'                                                    => '/var/log/opensearch',
    'plugins.security.allow_default_init_securityindex'            => true,
    'plugins.security.allow_unsafe_democertificates'               => true,
    'plugins.security.audit.type'                                  => 'internal_opensearch',
    'plugins.security.authcz.admin_dn'                             => [
      'CN=kirk,OU=client,O=client,L=test, C=de',
    ],
    'plugins.security.check_snapshot_restore_write_privileges'     => true,
    'plugins.security.disabled'                                    => false,
    'plugins.security.enable_snapshot_restore_privilege'           => true,
    'plugins.security.restapi.roles_enabled'                       => %w[
      all_access
      security_rest_api_access
    ],
    'plugins.security.ssl.http.enabled'                            => true,
    'plugins.security.ssl.http.pemcert_filepath'                   => 'esnode.pem',
    'plugins.security.ssl.http.pemkey_filepath'                    => 'esnode-key.pem',
    'plugins.security.ssl.http.pemtrustedcas_filepath'             => 'root-ca.pem',
    'plugins.security.ssl.transport.enforce_hostname_verification' => false,
    'plugins.security.ssl.transport.pemcert_filepath'              => 'esnode.pem',
    'plugins.security.ssl.transport.pemkey_filepath'               => 'esnode-key.pem',
    'plugins.security.ssl.transport.pemtrustedcas_filepath'        => 'root-ca.pem',
    'plugins.security.system_indices.enabled'                      => true,
    'plugins.security.system_indices.indices'                      => [
      '.plugins-ml-model',
      '.plugins-ml-task',
      '.opendistro-alerting-config',
      '.opendistro-alerting-alert*',
      '.opendistro-anomaly-results*',
      '.opendistro-anomaly-detector*',
      '.opendistro-anomaly-checkpoints',
      '.opendistro-anomaly-detection-state',
      '.opendistro-reports-*',
      '.opensearch-notifications-*',
      '.opensearch-notebooks',
      '.opensearch-observability',
      '.opendistro-asynchronous-search-response*',
      '.replication-metadata-store',
    ],
  }
  {
    ##
    ## version
    ##
    'version'                   => '2.5.0',

    ##
    ## package values
    ##
    'manage_package'            => true,
    'package_install_method'    => 'package',
    'package_ensure'            => 'present',
    'package_architecture'      => package_architecture,
    'package_provider'          => package_provider,
    'package_directory'         => '/opt/opensearch',

    ##
    ## opensearch settings
    ##
    'manage_config'             => true,
    'use_default_settings'      => true,
    'default_settings'          => default_settings,
    'settings'                  => {},

    ##
    ## java settings
    ##
    'heap_size'                 => '512m',

    ##
    ## service values
    ##
    'manage_service'            => true,
    'service_ensure'            => 'running',
    'service_enable'            => true,
    'restart_on_config_change'  => true,
    'restart_on_package_change' => true,
  }
end
