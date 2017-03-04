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

    let(:pre_condition) { 'file {"/usr/share/kibana/installedPlugins": ensure => directory}' }

    it 'installs the plugin' do
      should contain_kibana__plugin('marvel')
      should contain_exec('install_plugin_marvel').with(
        :command => 'kibana plugin --install elasticsearch/marvel/latest',
        :creates => '/kibana/installedPlugins/marvel/.name'
        )
      should contain_file('/kibana/installedPlugins/marvel/.name').with(
        :content => 'marvel'
        )
    end
  end

  context 'Add a plugin with version 5 via url' do
    let(:title) { 'x-pack' }
    let(:params) do {
      :source  => 'https://artifacts.elastic.co/downloads/packs/x-pack/x-pack-5.2.2.zip',
      :version => '5.2.2',
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

    it 'installs the plugin' do
      should contain_kibana__plugin('x-pack')
      should contain_exec('install_plugin_x-pack').with(
        :command => 'kibana-plugin --install x-pack --url https://artifacts.elastic.co/downloads/packs/x-pack/x-pack-5.2.2.zip',
        :creates => '/kibana/installedPlugins/x-pack/.name',
        )
      should contain_file('/kibana/installedPlugins/x-pack/.name').with(
        :content => 'x-pack'
        )
    end
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

    it 'removes the plugin' do
      should contain_kibana__plugin('marvel').with(:ensure => 'absent')
      should contain_exec('remove_plugin_marvel').with(
        :command => 'kibana plugin --remove marvel',
        :onlyif  => 'test -f /kibana/installedPlugins/marvel/.name',
      )
    end
  end
end
