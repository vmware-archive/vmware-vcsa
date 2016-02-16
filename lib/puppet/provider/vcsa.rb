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

  def servicecfg_catch(result)
    error = Hash[*result.split("\n").map{|x| x.split("=",2) if x =~ /^(?!Key not found)/ && x =~ /^(?!Stopping)/ && x =~ /=/ }.compact.flatten]
    raise Puppet::Error, "vpxd_servicecfg failure: Returned #{result.sub(/\n/, ', ')}" if error['VC_CFG_RESULT'] != '0'
  end
end
