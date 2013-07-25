#!/usr/bin/env rspec
# Copyright (C) 2013 VMware, Inc.

require 'spec_helper'

describe Puppet::Type.type(:vcsa_eula).provider(:default) do
  let(:name) { 'demo' }
  let(:ensure) { :accept }

  let(:resource) { Puppet::Type.type(:vcsa_eula).new(:name => name) }
  let(:provider) { resource.provider }

  before do
    @ssh = mock('ssh')
    provider.class.stubs(:transport).returns(@ssh)
  end

  it 'should determine if eula missing' do
    puts my_fixture_dir
    @ssh.stubs(:exec!).with('vpxd_servicecfg eula read').returns File.read(my_fixture('eula_missing'))
    provider.exists?.should == false
  end

  it 'should determine if eula accepted' do
    @ssh.stubs(:exec!).with('vpxd_servicecfg eula read').returns File.read(my_fixture('eula_accepted'))
    provider.exists?.should == true
  end
end
