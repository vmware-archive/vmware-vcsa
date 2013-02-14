# Copyright (C) 2013 VMware, Inc.
# This example is intended to fail to show net::ssh error propogate up:
# Error: /Stage[main]//Vcsa_eula[demo]: Could not evaluate: Connection refused - connect(2)
import 'data.pp'

transport { 'demo':
  username => $vcsa['username'],
  password => $vcsa['password'],
  server   => $vcsa['server'],
  # support connection options in net::ssh, except for symbol values (missing in Puppet):
  # http://net-ssh.github.com/net-ssh/classes/Net/SSH.html#method-c-start
  options  => { 'port' => 10022 },
}

vcsa_eula { 'demo':
  ensure    => accept,
  transport => Transport['demo'],
}
