#!/usr/bin/env rspec
# Copyright (C) 2013 VMware, Inc.

require 'spec_helper'

describe Puppet::Type.type(:vcsa_service).provider(:default) do
  let(:name) { 'demo' }
  let(:ensure) { :accept }

  let(:resource) { Puppet::Type.type(:vcsa_service).new(:name => name) }
  let(:provider) { resource.provider }

  before do
    @ssh = mock('ssh')
    provider.class.stubs(:transport).returns(@ssh)
  end

  it 'should determine if service stopped' do
    puts my_fixture_dir
    @ssh.stubs(:exec!).with('vpxd_servicecfg service status').returns File.read(my_fixture('service_stopped'))
    provider.exists?.should == false
  end

  it 'should determine if service running' do
    @ssh.stubs(:exec!).with('vpxd_servicecfg service status').returns File.read(my_fixture('service_running'))
    provider.exists?.should == true
  end
end
