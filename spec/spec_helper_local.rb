# frozen_string_literal: true

require 'shared_examples/config'
require 'shared_examples/install_archive'
require 'shared_examples/install_package'
require 'shared_examples/install'
require 'shared_examples/repository_debian'
require 'shared_examples/repository_redhat'
require 'shared_examples/repository'
require 'shared_examples/service'

require 'helper/get_defaults'

TESTS = {
  'with default value' => {},
  'with installation via archive and version 2.6.0' => {
    'version' => '2.6.0',
    'package_source' => 'archive',
  },
  'with installation via download and version 2.6.0' => {
    'version' => '2.6.0',
    'package_source' => 'download',
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
  'with some jvm gc settings' => {
    'jvm_gc_settings' => [
      '-XX:+UseG1GC',
      '-XX:G1ReservePercent=50',
      '-XX:InitiatingHeapOccupancyPercent=50',
    ],
  },
  'with only jvm gc logging settings given' => {
    'use_default_jvm_gc_logging_settings' => false,
    'jvm_gc_logging_settings' => [
      '-XX:+PrintGCApplicationStoppedTime',
      '-Xloggc:/var/log/opensearch/gc.log',
      '-XX:+UseGCLogFileRotation',
      '-XX:NumberOfGCLogFiles=32',
      '-XX:GCLogFileSize=64m',
    ],
  },
}.freeze
