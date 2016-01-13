# VMware vCSA module 

[![Build Status](https://travis-ci.org/vmware/vmware-vcsa.png?branch=master)](https://travis-ci.org/vmware/vmware-vcsa)

This module initializes and manages VMware vCenter Server Appliance (vCSA).

## Description

VMware vCenter Server Appliance does not include or support puppet agent. The
module manages vCSA through an intermediate host running puppet. The management
host connects to vCSA via ssh to perform the initialization and configuration:

    +------------+         +-------+
    |            |   ssh   | vCSA  |
    |   Puppet   | +-----> +-------+
    | Management |   |
    |    Host    |   |     +-------+
    |            |    ---> | vCSA  |
    +------------+         +-------+

A single management host can support any number of vCSA as long it has
connectivity to the appliances.

## Installation

$ puppet module install vmware/vcsa

## Usage

Deploy vCSA image to ESX (via ovftool). The following manifest will initialize
and configure the appliance with embedded database and sso:

    vcsa { 'test':
      username => 'root',
      password => 'vmware',
      server   => '192.168.1.10',
      db_type  => 'embedded',
      capacity => 'm',
    }

See init.pp for additional options, and 'vpxd_servicecfg help' for additional
information.

## Known Issues

In vCSA version 5.5 sshd_config MaxSessions needs to be increased above the
default value of 1 due to net-ssh opening multiple channels when invoking
ssh.exec!
