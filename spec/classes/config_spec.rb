require 'spec_helper'

describe 'kibana::config', :type => :class do

  let(:facts) { {
    :kernel => 'Linux',
    :http_proxy => false,
    :https_proxy => false,
  } }

  default_params = {
    :port                     => 5601,
    :bind                     => '0.0.0.0',
    :elasticsearch_ca_cert    => nil,
    :es_url                   => 'http://localhost:9200',
    :es_preserve_host         => true,
    :kibana_index             => '.kibana',
    :elasticsearch_username   => nil,
    :elasticsearch_password   => nil,
    :default_app_id           => 'discover',
    :pid_file                 => '/var/run/kibana.pid',
    :request_timeout          => 30000,
    :shard_timeout            => 0,
    :ssl_cert_file            => nil,
    :ssl_key_file             => nil,
    :elasticsearch_verify_ssl => true,
    :elasticsearch_cert_ssl   => nil,
    :elasticsearch_key_ssl    => nil,
    :install_path             => '/opt'
  }

  context 'with version 4.1 or lower' do

    let(:params) {
      default_params.merge({
        :version  => '4.1.5'
      })
    }

    it { should contain_file('/opt/kibana/config/kibana.yml').with_content(/^port:/) }

  end

  context 'with version 4.2' do

    let(:params) {
      default_params.merge({
        :version  => '4.2.0'
      })
    }

    it { should contain_file('/opt/kibana/config/kibana.yml').with_content(/^server\.port:/) }
    it { should contain_file('/opt/kibana/config/kibana.yml').without_content(/^port:/)}

  end

  context 'with version 4.1 and a basePath which is supported since 4.2' do

    let(:params) {
      default_params.merge({
        :version   => '4.1.5',
        :base_path => '/kibana'
      })
    }

    it { should compile.and_raise_error(/Kibana config: server.basePath is not supported for kibana 4.1 and lower/) }

  end

  context 'with version 4.6' do

    let(:params) {
      default_params.merge({
        :version                               => '4.6.3',
        :es_url                                => 'https://myhost:9200',
        :es_preserve_host                      => true,
        :elasticsearch_username                => 'kibanaserver',
        :elasticsearch_password                => 'thepassword',
        :default_app_id                        => 'marvel',
        :request_timeout                       => 9999,
        :shard_timeout                         => 1000,
        :ping_timeout                          => 1234,
        :startup_timeout                       => 5,
        :ssl_cert_file                         => '/ssl/cert',
        :ssl_key_file                          => '/ssl/key',
        :elasticsearch_verify_ssl              => true,
        :elasticsearch_ca_cert                 => '/elasticsearch/ca/cert',
        :elasticsearch_cert_ssl                => '/elasticsearch/cert/ssl',
        :elasticsearch_key_ssl                 => '/elasticsearch/key/ssl',
        :logging_silent                        => true,
        :logging_quiet                         => true,
        :logging_verbose                       => true,
        :ops_interval                          => 6000,
        :elasticsearch_requestHeadersWhitelist => [ 'authentication' ],
        :elasticsearch_customHeaders           => '{customheader:customcontent}',
        :log_file                              => 'test.log',
      })
    }

    it { should contain_file('/opt/kibana/config/kibana.yml').with_content(/^server\.port:/) }
    it { should contain_file('/opt/kibana/config/kibana.yml').without_content(/^ops\.interval:/) }
    it { should contain_file('/opt/kibana/config/kibana.yml').with_content(/elasticsearch\.customHeaders: \{customheader:customcontent\}/) }
    it { should contain_file('/opt/kibana/config/kibana.yml').without_content(/elasticsearch\.requestHeadersWhitelist: \[ authentication \]/) }

  end

  context 'with version 5.2.1' do

    let(:params) {
      default_params.merge({
        :version                               => '5.2.1',
        :es_url                                => 'https://myhost:9200',
        :es_preserve_host                      => true,
        :elasticsearch_username                => 'kibanaserver',
        :elasticsearch_password                => 'thepassword',
        :default_app_id                        => 'marvel',
        :request_timeout                       => 9999,
        :shard_timeout                         => 1000,
        :ping_timeout                          => 1234,
        :startup_timeout                       => 5,
        :ssl_cert_file                         => '/ssl/cert',
        :ssl_key_file                          => '/ssl/key',
        :elasticsearch_verify_ssl              => true,
        :elasticsearch_ca_cert                 => '/elasticsearch/ca/cert',
        :elasticsearch_cert_ssl                => '/elasticsearch/cert/ssl',
        :elasticsearch_key_ssl                 => '/elasticsearch/key/ssl',
        :logging_silent                        => true,
        :logging_quiet                         => true,
        :logging_verbose                       => true,
        :ops_interval                          => 6000,
        :elasticsearch_requestHeadersWhitelist => [ 'authentication' ],
        :elasticsearch_customHeaders           => '{customheader:customcontent}',
        :log_file                              => 'test.log',
        :security_enabled                      => true,
        :security_encryptionKey                => '012345678901234567890123456789012',
      })
    }

    it { should contain_file('/opt/kibana/config/kibana.yml').with_content(/^ops\.interval:/) }
    it { should contain_file('/opt/kibana/config/kibana.yml').with_content(/elasticsearch\.requestHeadersWhitelist: \[ authentication \]/) }
    it { should contain_file('/opt/kibana/config/kibana.yml').with_content(/elasticsearch\.customHeaders: \{customheader:customcontent\}/) }
    it { should contain_file('/opt/kibana/config/kibana.yml').with_content(/xpack\.security\.enabled: true/) }
    it { should contain_file('/opt/kibana/config/kibana.yml').with_content(/xpack\.security\.encryptionKey: 012345678901234567890123456789012/) }
  end


end
