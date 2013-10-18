#!/usr/bin/env rspec
# Copyright (C) 2013 VMware, Inc.

require 'spec_helper'

describe Puppet::Type.type(:vcsa_sso).provider(:default) do
  let(:name) { 'demo' }
  let(:ensure) { :accept }

  let(:resource) { Puppet::Type.type(:vcsa_sso).new(:name => name) }
  let(:provider) { resource.provider }

  before do
    @ssh = mock('ssh')
    provider.class.stubs(:transport).returns(@ssh)
  end

  it 'should determine if sso absent' do
    puts my_fixture_dir
    @ssh.stubs(:exec!).with('vpxd_servicecfg sso read').returns File.read(my_fixture('sso_absent'))
    provider.exists?.should == false
  end

  it 'should determine if sso present' do
    @ssh.stubs(:exec!).with('vpxd_servicecfg sso read').returns File.read(my_fixture('sso_present'))
    provider.exists?.should == true
  end
end
