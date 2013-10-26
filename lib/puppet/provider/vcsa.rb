# Copyright (C) 2013 VMware, Inc.
begin
  require 'puppet_x/puppetlabs/transport'
  require 'puppet_x/puppetlabs/transport/ssh'
rescue LoadError => detail
  require 'pathname' # WORK_AROUND #14073 and #7788
  mod = Puppet::Module.find('vmware_lib', Puppet[:environment].to_s)
  require File.join mod.path, 'lib/puppet_x/puppetlabs/transport'
  require File.join mod.path, 'lib/puppet_x/puppetlabs/transport/ssh'
end

class Puppet::Provider::Vcsa <  Puppet::Provider
  confine :feature => :ssh

  include PuppetX::Puppetlabs::Transport
end
