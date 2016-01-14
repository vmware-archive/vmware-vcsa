# Copyright (C) 2013 VMware, Inc.
Puppet::Type.newtype(:vcsa_timesync) do
  @doc = 'Manage vCSA timesync. Parameters to match /usr/sbin/vpxd_servicecfg timesync parameters. See /usr/sbin/vpxd_servicecfg -h on vCSA for additional information'

  ensurable

  newparam(:name, :namevar => true) do
  end

  newparam(:type) do
    desc 'vCSA timesync'
    newvalues('ntp', 'tools', 'none')
  end

  newparam(:ntp_servers) do
    desc 'vCSA timesync ntp servers - comma separate the list'
  end

  newparam(:ntp_options) do
    desc 'vCSA timesync ntp options'
  end
end
