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
end
