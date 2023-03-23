# frozen_string_literal: true

require 'spec_helper'
require 'spec_helper_local'

describe 'opensearch' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      defaults = get_defaults(facts)

      TESTS.each do |title, params|
        context "with #{title}" do
          parameter = defaults.merge(params)
          compiles  = true

          let(:params) do
            parameter
          end

          ##
          ## failures need to be handled here - they dont work in shared_examples
          ##
          if parameter['package_install_method'] == 'repository' && facts[:os]['family'] != 'RedHat'
            it {
              is_expected.to compile.and_raise_error(%r{not supported to use a repository for installing opensearch})
            }

            compiles = false
          end

          if compiles
            it {
              is_expected.to compile.with_all_deps
            }

            it {
              is_expected.to contain_class('opensearch')
            }

            it {
              is_expected.to contain_class('opensearch::params')
            }

            include_examples 'config', parameter, facts
            include_examples 'install', parameter, facts
            include_examples 'service', parameter, facts
          end
        end
      end
    end
  end
end
