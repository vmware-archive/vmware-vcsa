#!/usr/bin/env rspec
# Copyright (C) 2013 VMware, Inc.

require 'spec_helper'

describe Puppet::Type.type(:vcsa_db).provider(:default) do
  let(:name) { 'demo' }
  let(:ensure) { :accept }

  let(:resource) { Puppet::Type.type(:vcsa_db).new(:name => name) }
  let(:provider) { resource.provider }

  before do
    @ssh = mock('ssh')
    provider.class.stubs(:transport).returns(@ssh)
  end

  it 'should determine if db absent' do
    puts my_fixture_dir
    @ssh.stubs(:exec!).with('vpxd_servicecfg db read').returns File.read(my_fixture('db_absent'))
    provider.exists?.should == false
  end

  it 'should determine if db present' do
    @ssh.stubs(:exec!).with('vpxd_servicecfg db read').returns File.read(my_fixture('db_present'))
    provider.exists?.should == true
  end
end
