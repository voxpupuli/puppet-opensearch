# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'opensearch' do
  context 'default parameter' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        'include opensearch'
      end
    end

    describe package('opensearch') do
      it { is_expected.to be_installed }
    end

    describe service('opensearch') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe file('/etc/opensearch') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'opensearch' }
      it { is_expected.to be_grouped_into 'opensearch' }
    end

    describe file('/etc/opensearch/opensearch.yml') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'opensearch' }
      it { is_expected.to be_grouped_into 'opensearch' }
      it { is_expected.to contain 'cluster.name: opensearch' }
      it { is_expected.to contain 'http.port: 9200' }
    end
  end

  context 'uninstall' do
    it 'uninstalls' do
      apply_manifest(<<~PP, catch_failures: true)
        package { 'opensearch':
          ensure => purged,
        }
      PP
    end
  end

  context 'when installing from an archive' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PP
          class { 'opensearch':
            version        => '2.9.0',
            package_source => 'archive',
            settings       => {
              # When installing from an archive, the demo certificates are not
              # installed by default.
              'plugins.security.disabled' => true,
            },
          }
        PP
      end
    end

    describe service('opensearch') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
