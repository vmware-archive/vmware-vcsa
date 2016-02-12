# Copyright (C) 2013 VMware, Inc.
require 'pathname'
provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'vcsa')

Puppet::Type.type(:vcsa_timesync).provide(:ssh, :parent => Puppet::Provider::Vcsa ) do
  @doc = 'Manages vCSA timesync'

  def cmdparams
    if resource[:ntp_servers].nil?
      raise Puppet::Error, "Parmeter Missing: 'ntp_servers' must be set."
    end

    if resource[:ntp_options].nil?
      resource[:ntp_options] = "\'\'"
    end

    "\"#{resource[:ntp_servers]}\" #{resource[:ntp_options]}"
  end

  def read
    @read ||= transport.exec!('vpxd_servicecfg timesync read')
  end

  def create
    servicecfg_catch(transport.exec!("vpxd_servicecfg timesync write #{resource[:type]} #{cmdparams}"))
  end

  def vpxd_servicecfg
    @vpxd_servicecfg ||= Hash[*read.split("\n").map{|x| x.split("=",2) if x =~ /^(?!Key not found)/ && x =~ /=/ }.compact.flatten]
  end

  def exists?
    "#{resource[:ntp_servers]}" == vpxd_servicecfg['VC_TIMESYNC_NTP_SERVERS']
  end
end
