# Copyright (C) 2013 VMware, Inc.
Puppet::Type.newtype(:vcsa_java) do
  @doc = 'Manage vCSA java max.'

  ensurable

  newparam(:name, :namevar => true) do
  end

  newproperty(:tomcat) do
    desc 'vCSA jmx tomcat_memsize - maximum heap size for the Tomcat JVM in megabytes'
    newvalues(/\d+/)
  end

  newproperty(:inventory) do
    desc 'vCSA jmx inventory service - maximum heap size for the Inventory service JVM in megabytes'
    newvalues(/\d+/)
  end

  newproperty(:sps) do
    desc 'vCSA jmx sps - maximum heap size for the SPS service JVM in megabytes'
    newvalues(/\d+/)
  end
end
