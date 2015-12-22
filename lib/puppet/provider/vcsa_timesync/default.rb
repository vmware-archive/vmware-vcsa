# Copyright (C) 2013 VMware, Inc.
require 'pathname'
provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'vcsa')

# timesync target modes:
#   read         : read and return the current settings
#   write        : will test and save settings
#   test         : will test settings
#
# timesync Options for write/test:
#   [type] [servers] [options]
#      type     - ntp, tools or none
#      servers  - comma separated list of NTP servers (as a single argument, use quotes)
#      options  - ntpd recognized options to be added on each server line

# Option Tree:
#   read - no other options
#   write/test:
#     - type
#       - ntp
#       - tools
#       - none
#     - servers
#       - NTP Servers - comma separated, quoted, one argument
#     - options
#       - ntpd options to be added to each server

Puppet::Type.type(:vcsa_timesync).provide(:ssh, :parent => Puppet::Provider::Vcsa ) do
  @doc = 'Manages vCSA timesync'

  def cmdparams
    if resource[:ntp_servers].nil?
      raise Puppet::Error, "Parmeter Missing: 'ntp_servers' must be set."
    end

    if resource[:options].nil?
      resource[:options] = "\'\'"
    end

    "\"#{resource[:ntp_servers]}\" #{resource[:options]}"
  end

  def disable
    transport.exec!('vpxd_servicecfg timesync write none \'\' \'\'')
  end

  def read
    @read ||= transport.exec!('vpxd_servicecfg timesync read')
  end

  def create
    servicecfg_catch(transport.exec!("vpxd_servicecfg timesync write #{type} #{cmdparams}")
  end

  def test
    servicecfg_catch(transport.exec!("vpxd_servicecfg timesync test #{type} #{cmdparams}")
  end

  def vpxd_servicecfg
    @vpxd_servicecfg ||= Hash[*read.split("\n").map{|x| x.split("=",2) if x =~ /^(?!Key not found)/ }.compact.flatten]
  end

  def exists?
    "#{resource[:ntp_servers]}" = vpxd_servicecfg['VC_TIMESYNC_NTP_SERVERS']
  end
end
