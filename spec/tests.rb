# frozen_string_literal: true

TESTS = {
  'with default value' => {},
  'with installation via archive' => {
    'package_install_method' => 'archive',
  },
  'with installation via archive and version 2.6.0' => {
    'version' => '2.6.0',
    'package_install_method' => 'archive',
  },
  'with installation via repository' => {
    'package_install_method' => 'repository',
  },
  'with some settings given' => {
    'settings' => {
      'http_max_content_length' => 10,
      'indices_queries_cache_size' => 10,
    },
  },
  'with some settings given and no default settings' => {
    'use_default_settings' => false,
    'settings' => {
      'http_max_content_length' => 10,
      'indices_queries_cache_size' => 10,
    },
  },
}.freeze
