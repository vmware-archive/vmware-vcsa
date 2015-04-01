# Copyright (C) 2013 VMware, Inc.
Puppet::Type.newtype(:vcsa_sso) do
  @doc = 'Manage vCSA sso. Parameters to match /usr/sbin/vpxd_servicecfg sso parameters. See /usr/sbin/vpxd_servicecfg -h on vCSA for additional information'

  ensurable

  newparam(:name, :namevar => true) do
  end

  newparam(:password) do
    desc 'LS administrator password'
  end

  newparam(:login) do
    desc 'LS administrator account'
  end

  newparam(:thumbprint) do
    desc 'Optional thumbprint of the lookup service`s certificate'
  end

  newproperty(:dbtype) do
    desc 'vCSA dbtype -  embedded or external'
    newvalues('embedded', 'external')
  end

  newproperty(:ls) do
    desc 'Lookup service url'
  end

  newproperty(:principal) do
    desc 'Account to be assigned as VC admin'
  end

  newproperty(:is_group) do
    desc 'The principal account is a group'
    newvalues(:true, :false)
  end
end

