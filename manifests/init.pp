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
  $ntp_servers   = undef,
  $ntp_options   = '""',
  $sso_db_type   = 'embedded',
  $sso_ls        = undef,
  $sso_login     = undef,
  $sso_password  = undef,
  $sso_principal = undef,
  $sso_is_group  = undef,
  $sso_thumbprint = undef,
  $time_type     = 'ntp',
  $capacity      = 'small',    #: inventory accepts small, medium, large, custom
  $java_max_heap = undef,      #: manual jmx heap max size configuration
  $vpxd_state    = 'running'
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

  if $ntp_servers {
    vcsa_timesync { $name:
      ensure      => present,
      ntp_servers => $ntp_servers,
      ntp_options => $ntp_options,
      type        => $time_type,
      transport   => Transport[$name],
      before      => Vcsa_eula[$name]
    }
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
    ensure     => present,
    dbtype     => $sso_db_type,
    ls         => $sso_ls,
    login      => $sso_login,
    password   => $sso_password,
    principal  => $sso_principal,
    is_group   => $sso_is_group,
    thumbprint => $sso_thumbprint,
    transport  => Transport[$name],
  } ->

  vcsa_java { $name:
    ensure    => present,
    inventory => $jmx['is'],
    sps       => $jmx['sps'],
    tomcat    => $jmx['tomcat'],
    transport => Transport[$name],
  } ~>

  vcsa_service { $name:
    ensure    => $vpxd_state,
    transport => Transport[$name],
  }
}
