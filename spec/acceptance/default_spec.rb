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

    describe file('/opt/puppetlabs/puppet/cache/opensearch_cache_data/admin_password') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(%r{---}) }
    end

    describe command('/usr/share/opensearch/bin/opensearch --version') do
      its(:stdout) { is_expected.to match(%r{Version: 2.}) }
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  # rubocop:disable RSpec/RepeatedExampleGroupBody
  # rubocop:disable RSpec/RepeatedExampleGroupDescription
  context 'uninstall' do
    it 'uninstalls' do
      apply_manifest(<<~PP, catch_failures: true)
        package { 'opensearch':
          ensure => purged,
        }
      PP
    end
  end

  context 'install opensearch 3' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        'class{"opensearch": version => "3.9.0",}'
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

    describe file('/opt/puppetlabs/puppet/cache/opensearch_cache_data/admin_password') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(%r{---}) }
    end

    describe command('/usr/share/opensearch/bin/opensearch --version') do
      its(:stdout) { is_expected.to match(%r{Version: 3.9}) }
      its(:exit_status) { is_expected.to eq 0 }
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

    describe file('/usr/share/opensearch/bin/opensearch') do
      it { is_expected.not_to exist }
    end

    describe file('/opt/opensearch/bin/opensearch') do
      it { is_expected.not_to exist }
    end
    # rubocop:enable RSpec/RepeatedExampleGroupBody
    # rubocop:enable RSpec/RepeatedExampleGroupDescription
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

    describe command('/opt/opensearch/bin/opensearch --version') do
      its(:stdout) { is_expected.to match(%r{Version: 2.9.0}) }
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
