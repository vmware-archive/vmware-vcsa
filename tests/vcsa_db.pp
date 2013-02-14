# Copyright (C) 2013 VMware, Inc.
import 'data.pp'

transport { 'demo':
  username => $vcsa['username'],
  password => $vcsa['password'],
  server   => $vcsa['server'],
}

vcsa_db { 'demo':
  ensure    => present,
  type      => 'embedded',
  transport => Transport['demo'],
}
