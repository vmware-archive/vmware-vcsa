# VMware vCSA module

This module deploys and manages VMware vCSA.

## Installation

$ puppet module install vcenter/vcsa

## Usage

See init.pp for additional options:

    vcsa { 'test':
      username => 'root',
      password => 'vmware',
      server   => '192.168.1.10',
      db_type  => 'embedded',
      capacity => 'm',
    }
