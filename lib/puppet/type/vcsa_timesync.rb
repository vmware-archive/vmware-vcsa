# Copyright (C) 2013 VMware, Inc.
Puppet::Type.newtype(:vcsa_timesync) do
  @doc = 'Manage vCSA timesync. Parameters to match /usr/sbin/vpxd_servicecfg timesync parameters. See /usr/sbin/vpxd_servicecfg -h on vCSA for additional information'

  ensurable

  newparam(:name, :namevar => true) do
  end

  newproperty(:type) do
    desc 'vCSA dbtype -  embedded or external'
    newvalues('ntp', 'tools', 'none')
  end

  newproperty(:ntp1) do
    desc 'vCSA timesync first ntp server'
  end

  newproperty(:ntp2) do
    desc 'vCSA timesync second ntp server'
  end

  newproperty(:options) do
    desc 'vCSA timesync options'
  end
end
