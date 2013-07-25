# Copyright (C) 2013 VMware, Inc.
# vCSA appliance configuration.
define vcsa (
  $username      = 'root',     #: vcsa appliance username
  $password      = 'vmware',   #: vcsa appliance password
  $server,                     #: vCSA appliance server name or ip address
  $ssh_options   = { 'user_known_hosts_file' => '/dev/null' },
  $db_type       = 'embedded',
  $db_server     = undef,
  $db_port       = undef,
  $db_instance   = undef,
  $db_user       = undef,
  $db_password   = undef,
  $capacity      = 'small',    #: inventory accepts small, medium, large, custom
  $java_max_heap = undef       #: manual jmx heap max size configuration
) {

  case $capacity {
    's', 'small': {
      $jmx = {
        'tomcat' => 1024,
        'is'     => 2048,
        'sps'    => 512,
      }
    }
    'm', 'medium': {
      $jmx = {
        'tomcat' => 2048,
        'is'     => 2096,
        'sps'    => 1024,
      }
    }
    'l', 'large': {
      $jmx = {
        'tomcat' => 3072,
        'is'     => 6144,
        'sps'    => 2048,
      }
    }
    'custom': {
      $jmx = $java_max_heap
    }
    default: {
      fail("Unknown capacity ${capacity} (accepts: small, medium, large, custom)")
    }
  }

  transport { $name:
    username => $username,
    password => $password,
    server   => $server,
    options  => $ssh_options,
  }

  vcsa_eula { $name:
    ensure    => accept,
    transport => Transport[$name],
  } ->

  vcsa_db { $name:
    ensure    => present,
    type      => $db_type,
    server    => $db_server,
    port      => $db_port,
    instance  => $db_instance,
    user      => $db_user,
    password  => $db_password,
    transport => Transport[$name],
  } ->

  vcsa_sso { $name:
    ensure    => present,
    dbtype    => $db_type,
    server    => $db_server,
    port      => $db_port,
    instance  => $db_instance,
    user      => $db_user,
    password  => $db_password,
    transport => Transport[$name],
  } ->

  vcsa_java { $name:
    ensure    => present,
    inventory => $jmx['is'],
    sps       => $jmx['sps'],
    tomcat    => $jmx['tomcat'],
    transport => Transport[$name],
  } ~>

  vcsa_service { $name:
    ensure    => running,
    transport => Transport[$name],
  }
}
