# Copyright (C) 2013 VMware, Inc.
begin
  require 'puppet_x/puppetlabs/transport'
rescue LoadError => detail
  require 'pathname' # WORK_AROUND #14073 and #7788
  vmware_module = Puppet::Module.find('vmware_lib', Puppet[:environment].to_s)
  require File.join vmware_module.path, 'lib/puppet_x/puppetlabs/transport'
end

begin
  require 'puppet_x/puppetlabs/transport/ssh'
rescue LoadError => detail
  require 'pathname' # WORK_AROUND #14073 and #7788
  module_lib = Pathname.new(__FILE__).parent.parent.parent
  require File.join module_lib, 'puppet_x/puppetlabs/transport/ssh'
end


class Puppet::Provider::Vcsa <  Puppet::Provider
  confine :feature => :ssh

  def self.transport(resource)
    @transport ||= PuppetX::Puppetlabs::Transport.retrieve(:resource_ref => resource[:transport], :catalog => resource.catalog, :provider => 'ssh')
  end

  def transport
    self.class.transport(resource)
  end
end
