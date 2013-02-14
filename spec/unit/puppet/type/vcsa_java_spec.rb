#!/usr/bin/env rspec
# Copyright (C) 2013 VMware, Inc.

require 'spec_helper'

vcsa = Puppet::Type.type(:vcsa_java)

describe vcsa do
  before :each do
    @type = vcsa
    @provider = stub 'provider'

    @resource = @type.new({
      :name      => 'java',
      :tomcat    => '1024',
      :inventory => '2048',
      :sps       => '1024',
    })
  end

  it 'should have name as :namevar.' do
    @type.key_attributes.should == [:name]
  end

  it "should only accept numbers for property" do
    [:tomcat, :inventory, :sps].each do |prop|
      lambda { @resource[prop] = 'val' }.should raise_error(Puppet::Error)
      @resource[prop] = 1000
      @resource[prop].should == 1000
    end
  end
end
