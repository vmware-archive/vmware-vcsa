# Copyright (C) 2013 VMware, Inc.
require 'pathname'
provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'vcsa')

Puppet::Type.type(:vcsa_sso).provide(:ssh, :parent => Puppet::Provider::Vcsa ) do
  @doc = 'Manages vCSA sso'

  def addparam(paramlist, param_validation, param)
    if resource[param].nil?
      param_validation.push(param) unless param == 'is_group'
    else
      if param == 'thumbprint' && resource[:is_group].nil?
        raise Puppet::Error, "Parmeter Missing: 'is_group' must be set if supplying values for 'thumbprint'"
      end
      paramlist += " '#{resource[param]}'"
    end
    paramlist
  end

  def cmdparams
    param_order = ['dbtype','ls','login','password','principal','is_group','thumbprint']
    param_validation = []
    param_list = ""
    param_order.each { |param|
      case param
      when 'ls','login','principal','is_group','thumbprint'
        if resource[:dbtype].to_s == 'external'
          param_list = addparam param_list, param_validation, param
        end
      when 'password'
        if resource[:dbtype].to_s == 'external'
          param_list = addparam param_list, param_validation, param
        elsif resource[:dbtype].to_s == 'embedded'
          Puppet.warning "No password provided for embedded SSO database. A new password will not be set for administrator@vsphere.local" if resource[param].nil? 
          param_list += " '#{resource[param]}'"
        end
      else
        param_list = addparam param_list, param_validation, param
      end
    }
    raise Puppet::Error, "The following parameters are missing for a database type of #{resource[:dbtype]} : #{param_validation.inspect}" unless param_validation.empty?
    param_list
  end

  def command
    @command ||= "vpxd_servicecfg sso write#{cmdparams}"
  end

  def create
    transport.exec!(command)
  end

  def exists?
    result = transport.exec!('vpxd_servicecfg sso read')
    result = Hash[*result.split("\n").map{|x| x.split("=",2) if x =~ /^(?!Key not found)/ }.compact.flatten]
    result['SSO_TYPE'] != ""
  end
end

