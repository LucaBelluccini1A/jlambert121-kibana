#   =  = Class: kibana::params
#
# This class sets default parameters
#
#
class kibana::params {
  $version                               = '4.0.1'
  $base_url                              = undef
  $elasticsearch_ca_cert                 = undef
  $install_path                          = '/opt'
  $tmp_dir                               = '/tmp'
  $port                                  = 5601
  $bind                                  = '0.0.0.0'
  $es_url                                = 'http://localhost:9200'
  $es_preserve_host                      = true
  $kibana_index                          = '.kibana'
  $elasticsearch_username                = undef
  $elasticsearch_password                = undef
  $default_app_id                        = 'discover'
  $request_timeout                       = 300000
  $shard_timeout                         = 0
  $ping_timeout                          = 1500
  $startup_timeout                       = 5000
  $ssl_cert_file                         = undef
  $ssl_key_file                          = undef
  $elasticsearch_verify_ssl              = true
  $elasticsearch_cert_ssl                = undef
  $elasticsearch_key_ssl                 = undef
  $group                                 = 'kibana'
  $user                                  = 'kibana'
  $base_path                             = undef
  $log_file                              = '/var/log/kibana/kibana.log'
  $logging_silent                        = false
  $logging_quiet                         = false
  $logging_verbose                       = false
  $ops_interval                          = 5000
  $elasticsearch_requestHeadersWhitelist = undef
  $elasticsearch_customHeaders           = undef
  $manage_user                           = true
  $manage_group                          = true
  $security_enabled                      = undef
  $security_encryptionKey                = undef
  $security_sessionTimeout               = undef
  $security_skipSslCheck                 = undef
  $security_cookieName                   = undef
  $security_secureCookies                = undef

  # Download tool

  case $::kernel {
    'Linux': {
      $download_tool = 'wget --no-check-certificate -O'
    }
    'Darwin': {
      $download_tool = 'curl --insecure -o'
    }
    'OpenBSD': {
      $download_tool = 'ftp -o'
    }
    default: {
      fail("\"${module_name}\" provides no download tool default value
           for \"${::kernel}\"")
    }
  }

  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'OracleLinux', 'SLC': {

      if versioncmp($::operatingsystemmajrelease, '7') >= 0 {
        $service_provider        = 'systemd'
        $systemd_provider_path   = '/usr/lib/systemd/system'
        $run_path                = '/run/kibana'
      } else {
        $service_provider        = 'init'
        $run_path                = '/var/run'
        $init_script_osdependend = 'kibana.legacy.service.redhat.erb'
      }

    }

    'Debian': {

      if versioncmp($::operatingsystemmajrelease, '8') >= 0 {
        $service_provider      = 'systemd'
        $systemd_provider_path = '/lib/systemd/system'
        $run_path              = '/run/kibana'
      } else {
        $service_provider        = 'init'
        $run_path                = '/var/run'
        $init_script_osdependend = 'kibana.legacy.service.debian.erb'
      }
    }

    'Ubuntu': {

      if versioncmp($::operatingsystemmajrelease, '15') >= 0 {
        $service_provider      = 'systemd'
        $systemd_provider_path = '/usr/lib/systemd/system'
        $run_path              = '/run/kibana'
      } else {
        $service_provider        = 'init'
        $run_path                = '/var/run'
        $init_script_osdependend = 'kibana.legacy.service.debian.erb'
      }
    }

    'OpenSuSE': {
      $service_provider      = 'systemd'
      $systemd_provider_path = '/usr/lib/systemd/system'
      $run_path              = '/run/kibana'
    }

    'Amazon': {
      $service_provider        = 'init'
      $init_script_osdependend = 'kibana.legacy.service.redhat.erb'
    }

    default: {
      $service_provider        = 'init'
      $run_path                = '/var/run'
      $init_script_osdependend = 'kibana.legacy.service.redhat.erb'
    }
  }

  $pid_file = "${run_path}/kibana.pid"
}
