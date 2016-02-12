# Copyright (C) 2013 VMware, Inc.
require 'pathname'
provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'vcsa')

Puppet::Type.type(:vcsa_service).provide(:ssh, :parent => Puppet::Provider::Vcsa ) do
  @doc = 'Manages vCSA service'

  def create
    servicecfg_catch(transport.exec!('vpxd_servicecfg service start'))
  end

  def destroy
    transport.exec!('vpxd_servicecfg service stop')
  end

  def exists?
    result = transport.exec!('vpxd_servicecfg service status')
    result = Hash[*result.split("\n").collect{|x| x.split('=',2) if x =~ /=/}.compact.flatten]
    result['VC_SERVICE_STATUS'] != '0'
  end
end
