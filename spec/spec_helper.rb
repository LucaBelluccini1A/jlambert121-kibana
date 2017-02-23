require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'puppetlabs_spec_helper/module_spec_helper'

Puppet::Util::Log.level = :debug
Puppet::Util::Log.newdestination(:console)
