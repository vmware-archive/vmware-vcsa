#!/usr/bin/env rspec
# Copyright (C) 2013 VMware, Inc.

require 'spec_helper'

describe Puppet::Type.type(:vcsa_java).provider(:default) do
  let(:name) { 'demo' }
  let(:ensure) { :accept }

  let(:resource) { Puppet::Type.type(:vcsa_java).new(:name => name) }
  let(:provider) { resource.provider }

  before do
    @ssh = mock('ssh')
    provider.class.stubs(:transport).returns(@ssh)
  end

  it 'should determine java settings' do
    puts my_fixture_dir
    @ssh.stubs(:exec!).with('vpxd_servicecfg jvm-max-heap read').returns File.read(my_fixture('java'))
    provider.exists?
    provider.inventory.should == '6144'
    provider.sps.should == '2048'
    provider.tomcat.should == '3072'
  end

end
