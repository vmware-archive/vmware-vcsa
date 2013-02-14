# Copyright (C) 2013 VMware, Inc.
Puppet::Type.newtype(:vcsa_db) do
  @doc = 'Manage vCSA db.'

  ensurable

  newparam(:name, :namevar => true) do
  end

  newparam(:type) do
    desc 'vCSA database type - oracle, PostgreSQL or embedded'
    newvalues('oracle', 'PostgreSQL', 'embedded')
  end

  newparam(:server) do
    desc 'vCSA database server - name or ip of DB server'
  end

  newparam(:port) do
    desc 'vCSA database port - port number for DB, set to 0 to use default'
    newvalues(/\d+/)
  end

  newparam(:instance) do
    desc 'vCSA database instance - database instance name'
  end

  newparam(:user) do
    desc 'vCSA database user - db user name'
  end

  newparam(:password) do
    desc 'vCSA database password - db user password'
  end
end
