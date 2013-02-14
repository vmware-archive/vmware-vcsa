# Copyright (C) 2013 VMware, Inc.
import 'data.pp'

vcsa { 'demo':
  username => $vcsa['username'],
  password => $vcsa['password'],
  server   => $vcsa['server'],
  db_type  => 'embedded',
  capacity => 'm',
}
