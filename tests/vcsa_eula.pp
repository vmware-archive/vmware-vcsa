import 'data.pp'

transport { 'demo':
  username => $vcsa['username'],
  password => $vcsa['password'],
  server   => $vcsa['server'],
}

vcsa_eula { 'demo':
  ensure    => accept,
  transport => Transport['demo'],
}
