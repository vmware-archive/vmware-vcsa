Puppet::Type.newtype(:vcsa_sso) do
  @doc = 'Manage vCSA sso.'

  ensurable

  newparam(:name, :namevar => true) do
  end

  newparam(:dbtype) do
    desc 'vCSA embedded dbtype - oracle, PostgreSQL, embedded or vcdb'
    newvalues('oracle', 'PostgreSQL', 'embedded', 'vcdb')
  end

  newparam(:server) do
    desc 'vCSA embedded server - name or ip of DB server'
  end

  newparam(:port) do
    desc 'vCSA embedded port - port number for DB, set to 0 to use default'
    newvalues(/\d+/)
  end

  newparam(:instance) do
    desc 'vCSA embedded instance - database instance name'
  end

  newparam(:user) do
    desc 'vCSA embedded user - db user name'
  end

  newparam(:password) do
    desc 'vCSA embedded password - db user password'
  end
end

