#!/usr/bin/env rspec
# Copyright (C) 2013 VMware, Inc.

require 'spec_helper'

vcsa = Puppet::Type.type(:vcsa_eula)

describe vcsa do
  before :each do
    @type = vcsa
    @provider = stub 'provider'

    @resource = @type.new({
      :name   => 'eula',
      :ensure => 'present',
    })
  end

  it 'should have name as :namevar.' do
    @type.key_attributes.should == [:name]
  end
end
