#!/usr/bin/env rspec
# Copyright (C) 2013 VMware, Inc.

require 'spec_helper'

vcsa = Puppet::Type.type(:vcsa_sso)

describe vcsa do
  before :each do
    @type = vcsa
    @provider = stub 'provider'

    @resource = @type.new({
      :name     => 'sso',
      :dbtype   => 'embedded',
      :server   => 'localhost',
      :port     => '5432',
      :instance => '',
      :user     => '',
      :password => '',
    })
  end

  it 'should have name as :namevar.' do
    @type.key_attributes.should == [:name]
  end
end

