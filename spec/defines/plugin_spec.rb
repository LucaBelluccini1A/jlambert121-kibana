require 'spec_helper'

describe 'kibana::plugin', :type => :define do

  context 'Add a plugin' do
    let(:title) { 'marvel' }
    let(:params) do {
      :source => 'elasticsearch/marvel/latest',
      :version => '4.6.1'
    } end

    let (:facts) { {
      :operatingsystem => 'CentOS',
      :kernel => 'Linux',
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :http_proxy => false,
      :https_proxy => false,
      :architecture => 'amd64'
    } }

    it { should contain_kibana__plugin('marvel')}
    it { should contain_exec('install_plugin_marvel').with(
      :command => 'kibana plugin --install elasticsearch/marvel/latest',
      ).that_requires('File[/usr/share/kibana/installedPlugins]')}
    it { should contain_file('/usr/share/kibana/installedPlugins/marvel/.name').with(
      :content => 'marvel',
      )}

  end

  context 'Remove a plugin' do
    let(:title) { 'marvel' }
    let(:params) do {
      :source => 'elasticsearch/marvel/latest',
      :ensure => 'absent'
    } end

    let (:facts) { {
      :operatingsystem => 'CentOS',
      :kernel => 'Linux',
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :http_proxy => false,
      :https_proxy => false,
      :architecture => 'amd64'
    } }

    it { should contain_kibana__plugin('marvel').with(:ensure => 'absent') }
  end
end
