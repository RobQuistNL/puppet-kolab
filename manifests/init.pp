# = Class: kolab
#
# This is the main kolab class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# See README for usage patterns.
#
class kolab (
    $disable = false,
    $absent = false,
    $version = '3.0',
  ) inherits kolab::params {

  class {'kolab::dependencies': 
    version => $version,
  }

  file { "/etc/apt/apt.conf.d/99auth": #since we can't really add --force-yes to the apt-get install.       
    owner     => root,
    group     => root,
    content   => "APT::Get::AllowUnauthenticated yes;",
    mode      => 644;
  }

  package { ['libmozldap-0d', 'mozldap-tools']:
    ensure => installed,
    require => File['/etc/apt/apt.conf.d/99auth'],
  }

  package {'kolab':
    ensure => installed,
    require => Exec['smarty-3'],
  }

  package {'kolab-webadmin':
    ensure => installed,
    require => Package['kolab'],
  }

  exec { "rm /etc/apt/apt.conf.d/99auth": } #Remove the ugly hack

  #exec {'setup-kolab': 
  #  require => Package['kolab-webadmin']
  #}

  File ['/etc/apt/apt.conf.d/99auth'] -> Package ['kolab']
  Package ['kolab-webadmin'] -> Exec ['rm /etc/apt/apt.conf.d/99auth']

}
