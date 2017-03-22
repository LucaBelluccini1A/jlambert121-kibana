# == Class: kibana::config
#
# This class configures kibana.  It should not be directly called.
#
#
class kibana::config (
  $version                               = $::kibana::version,
  $install_path                          = $::kibana::install_path,
  $port                                  = $::kibana::port,
  $bind                                  = $::kibana::bind,
  $elasticsearch_ca_cert                 = $::kibana::elasticsearch_ca_cert,
  $es_url                                = $::kibana::es_url,
  $es_preserve_host                      = $::kibana::es_preserve_host,
  $kibana_index                          = $::kibana::kibana_index,
  $elasticsearch_username                = $::kibana::elasticsearch_username,
  $elasticsearch_password                = $::kibana::elasticsearch_password,
  $default_app_id                        = $::kibana::default_app_id,
  $pid_file                              = $::kibana::pid_file,
  $request_timeout                       = $::kibana::request_timeout,
  $shard_timeout                         = $::kibana::shard_timeout,
  $ping_timeout                          = $::kibana::ping_timeout,
  $startup_timeout                       = $::kibana::startup_timeout,
  $ssl_cert_file                         = $::kibana::ssl_cert_file,
  $ssl_key_file                          = $::kibana::ssl_key_file,
  $elasticsearch_verify_ssl              = $::kibana::elasticsearch_verify_ssl,
  $elasticsearch_cert_ssl                = $::kibana::elasticsearch_cert_ssl,
  $elasticsearch_key_ssl                 = $::kibana::elasticsearch_key_ssl,
  $logging_silent                        = $::kibana::logging_silent,
  $logging_quiet                         = $::kibana::logging_quiet,
  $logging_verbose                       = $::kibana::logging_verbose,
  $ops_interval                          = $::kibana::ops_interval,
  $elasticsearch_requestHeadersWhitelist = $::kibana::elasticsearch_requestHeadersWhitelist,
  $elasticsearch_customHeaders           = $::kibana::elasticsearch_customHeaders,
  $base_path                             = $::kibana::base_path,
  $log_file                              = $::kibana::log_file,
  $security_encryptionKey                = $::kibana::security_encryptionKey,
  $security_sessionTimeout               = $::kibana::security_sessionTimeout,
  $security_skipSslCheck                 = $::kibana::security_skipSslCheck,
  $security_enabled                      = $::kibana::security_enabled,
  $security_cookieName                   = $::kibana::security_cookieName,
  $security_secureCookies                = $::kibana::security_secureCookies,
){

  if $security_enabled {
    validate_bool($security_enabled)
  }
  if $security_encryptionKey {
    validate_string($security_encryptionKey) 
  }
  if $security_sessionTimeout {
    validate_integer($security_sessionTimeout)
  }
  if $security_skipSslCheck {
    validate_bool($security_skipSslCheck)
  }
  if $security_cookieName {
    validate_string($security_cookieName)
  }
  if $security_secureCookies {
    validate_bool($security_secureCookies)
  }

  case $version {
    /^4\.[01]/: {
      if $base_path {
        fail('Kibana config: server.basePath is not supported for kibana 4.1 and lower')
      }
      $template = 'kibana-4.0.yml'
    }
    /^4\.6/: {
      $template = 'kibana-4.6.yml'
    }
    /^4\./: {
      $template = 'kibana-4.2.yml'
    }
    /^5\./: {
      $template = 'kibana-5.x.yml'
    }
    default: {
      fail('Kibana version not supported')
    }
  }

  file { "${install_path}/kibana/config/kibana.yml":
    ensure  => 'file',
    owner   => 'kibana',
    group   => 'kibana',
    mode    => '0440',
    content => template("kibana/${template}.erb"),
  }
}
